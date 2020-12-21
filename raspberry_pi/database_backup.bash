#!/bin/bash

source /home/$(whoami)/git_projects/scripts/setup/config.txt

partial_filename=expense_report
base_filename=expense_report.db

expense_report_db=${GIT_BASE}/expense_report/db/${base_filename}
database_backup_base=/media/HDD_4TB_01/databases
database_backup_location=${database_backup_base}/backup
backup_db_name=${database_backup_base}/${base_filename}

mkdir -p ${database_backup_base}

sha256_original=$(sha256sum ${expense_report_db} | tr -s ' ' | cut -d ' ' -f1)
sha256_backup=$(sha256sum ${backup_db_name} | tr -s ' ' | cut -d ' ' -f1)

if [[ "${sha256_original}" != "${sha256_original}" ]]
then
    cp ${backup_db_name} "${database_backup_location}/${partial_filename}_$(date +%Y%m%d).db"
    cp ${expense_report_db} ${backup_db_name}
else
    echo "nothing new to backup"
fi
