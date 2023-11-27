import glob
import warnings
import traceback
from lib.file_info import FileInfo
from lib.enviroments import get_env
from lib.excel_processing import extract_from_excel
from lib.sql_processing import make_column_definition

# Excelファイルにデータ検証(Data Validation)の拡張が含まれているけど、
# その拡張は openpyxl ライブラリでサポートされていないという意味です。
# そのため、読み込むExcelファイルがこの拡張を必要としない場合には問題ありません。
warnings.filterwarnings("ignore", message="Data Validation extension is not supported and will be removed")


def write_to_file(s_name: str, t_name: str, ddl: str) -> None:
    """ "SQL文をファイルに書き込み"""
    with open(f"./output/{s_name}.{t_name}.sql", "w", encoding="utf-8") as file:
        file.write(ddl)


def main():
    try:
        env = get_env()
        files = [file for file in glob.glob("./input/*.xlsx") if "~$" not in file]
        if not files:
            raise ValueError("file did not exist.")
        print("files:", files)
        for file in files:
            table_name, schema_name, table = extract_from_excel(file, env)
            column_lengths = table[env["COLUMN_NAME"]].apply(lambda x: len(str(x)))
            max_column_length = max(column_lengths)
            ddl = f"CREATE TABLE IF NOT EXISTS {schema_name}.{table_name}(\n"
            file_info = FileInfo(ddl, max_column_length)
            for _, row in table.iterrows():
                file_info.column_name = row[env["COLUMN_NAME"]]
                file_info.data_type = row[env["DATA_TYPE"]]
                file_info.digits = row[env["DIGITS"]]
                file_info.decimal_part = row[env["DECIMAL_PART"]]
                file_info.primary_key = row[env["PRIMARY_KEY"]]
                file_info.is_not_null = row[env["NOT_NULL"]]
                file_info.default_value = row[env["DEFAULT_VALUE"]]
                # 全て含む場合
                if {
                    file_info.column_name,
                    file_info.decimal_part,
                    file_info.data_type,
                    file_info.digits,
                    file_info.primary_key,
                    file_info.default_value,
                } == {"-"}:
                    continue
                elif file_info.data_type in env["REDSHIFT_DATA_TYPES"].split(","):
                    if file_info.primary_key != "-":
                        file_info.primary_key_list = file_info.column_name
                    make_column_definition(file_info)
                else:
                    print("error record:", vars(file_info))
                    raise ValueError("There is no data type. Tracking your self or  ask the administorator")
            if file_info.primary_key_list != []:
                file_info.ddl += "    PRIMARY KEY (" + ", ".join(file_info.primary_key_list) + ")\n"
            file_info.ddl = file_info.ddl.rstrip(",\n") + "\n)\nDISTSTYLE AUTO\nSORTKEY AUTO;"
            write_to_file(schema_name, table_name, file_info.ddl)
        print("successfull")
    except Exception:
        print("error file:", file)
        traceback.print_exc()


if __name__ == "__main__":
    main()