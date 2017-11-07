# volby.cz parser

## How to use

* set your database credentials in `etc/pgsql.env`
* run `psql -f structure.sql` inside `lib/psql`
* set variables in `etc/settings.env`
* run scripts from `bin` folder
  * `extract_enums.sh` downloads list of administrative units
  * `transform_enums.sh` transforms the list to a file readable by `wget`
  * `extract_data.sh` downloads the data for given election
  * `transform_data.sh` converts downloaded XML files to CSV
  * `load_data.sh` loads CSV files into PostgreSQL database

## Configuration

* `PG*` variables are expected to be defined when running ETL process (`etc/pgsql.env` might be a good place to start)
* `etc/settings.env` is **automatically** sourced when needed during ETL process
  * `ENUMS_URL` is the administrative units XML/CSV/DBF files location
  * `ENUMS_ZIP` defines the location of a downloaded zip file
  * `RESULTS_URL` is the base url of XML election results
  * `FOREIGN_RESULTS_URL` is the location of XML election results from foreign countries
  * `FOREIGN_RESULTS_REGION_ID` is the id of a region that accumulates the votes coming from foreign countries (has to match the `elections.municipality` region_id)

## Dependencies

* Bash: GNU Parallel, wget, dbview, gnumeric
* Python
* PostgreSQL + PostGIS
