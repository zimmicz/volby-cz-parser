#!/usr/bin/env python
# -*- coding: utf-8 -*-

import datetime
import os
import re
import sys
import xml.etree.ElementTree as ET


def get_output_filename(output_folder, input_filename, output_suffix):
    return "{}/{}".format(output_folder, input_filename.split("/")[-1].replace(".xml", output_suffix))


def get_namespace():
    default_namespace = {'czso': 'http://www.w3.org/namespace/'}
    m = re.match('\{.*\}', root.tag)
    if m:
        default_namespace['czso'] = m.group(0).strip('{}')

    return default_namespace


def get_top_element():
    elm = 'czso:OBEC'

    if root.tag.endswith('VYSLEDKY_ZAHRANICI'):
        elm = '//czso:STAT'

    return elm


def parse_xml():
    ns = get_namespace()
    top_elm = get_top_element()

    start = root
    if top_elm.startswith('//'):
        start = tree

    with open(output_filename_muni, "w") as muni, open(output_filename_subject, "w") as party:

        for elm in start.findall(top_elm, ns):
            if elm.get('TYP_OBEC') == "OBEC_S_MCMO":
                continue

            muni_id = elm.get('CIS_OBEC')

            if muni_id is None and top_elm.startswith('//'):
                muni_id = '-1'

            for attendance in elm.findall('czso:UCAST', ns):
                data = [
                    muni_id,
                    attendance.get('OKRSKY_CELKEM'),
                    attendance.get('OKRSKY_ZPRAC'),
                    attendance.get('OKRSKY_ZPRAC_PROC'),
                    attendance.get('ZAPSANI_VOLICI'),
                    attendance.get('VYDANE_OBALKY'),
                    attendance.get('UCAST_PROC'),
                    attendance.get('ODEVZDANE_OBALKY'),
                    attendance.get('PLATNE_HLASY'),
                    attendance.get('PLATNE_HLASY_PROC')
                ]
                muni.write(",".join(data))
                muni.write("\n")

            for votes in elm.findall('czso:HLASY_STRANA', ns):
                party_id = votes.get('KSTRANA')
                votes_abs = votes.get('HLASY')
                votes_ratio = votes.get('PROC_HLASU')
                party.write(u",".join([muni_id, party_id, votes_abs, votes_ratio]))
                party.write("\n")


if __name__ == '__main__':
    filename = sys.argv[2]
    output_folder = sys.argv[1]
    output_filename_muni = get_output_filename(output_folder, filename, "_muni.csv")
    output_filename_subject = get_output_filename(output_folder, filename, "_subject.csv")
    tree = ET.parse(filename)
    root = tree.getroot()

    parse_xml()
