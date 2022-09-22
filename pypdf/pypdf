#! /usr/bin/env python
#
# python 3.10
# Объединяет pdf-файлы в один много-страничный документ с закладками.
# Имена закладок соответствуют именам добавляемых файлов.
#

import argparse
import os
import sys
import pikepdf


def create_pdf_bookmarks(file_list, file_name_output):
    # Создать pdf-файл из file_list.
    pdf = pikepdf.Pdf.new()
    page_count = 0
    _title = os.path.basename(os.path.dirname(file_list[0]))
    # Добавить закладки по имени файла из file_list.
    with pdf.open_outline() as outline:
        for file in file_list:
            files_pdf = pikepdf.Pdf.open(file)
            page_name = os.path.splitext(os.path.basename(file))[0]
            bookmark = pikepdf.OutlineItem(page_name, page_count)
            outline.root.append(bookmark)
            page_count += len(files_pdf.pages)
            pdf.pages.extend(files_pdf.pages)
    # Добавляем meta данные
    with pdf.open_metadata() as records:
        records['dc:title'] = _title
        records['dc:creator'] = [os.getlogin()]
        records['xmp:CreatorTool'] = 'pdf utils 1.0.16'
    # Записать в file_name_output.
    pdf.save(file_name_output)
    return


def merge_files_directories(dir_name, file_name_output, prog):
    # Объединяем все файлы из директории dir_name в файл file_name_output.
    # Читаем содержимое директории dir_name, проверяем наличие pdf-файлов, если нет завершаем программу.
    file_list = [os.path.join(dir_name, files) for files in sorted(filter(lambda file_ext: file_ext.endswith('.pdf'), os.listdir(dir_name)))]
    if not file_list:
        sys.exit(f'{prog}: error: There are no pdf files in the presented list.')
    # Создаем pdf-файл из file_list
    create_pdf_bookmarks(file_list, file_name_output)
    return


def merge_files_list(file_list, file_name_output, prog):
    # Объединяем файлы из списка file_list в файл file_name_output.
    # Проверяем список file_list, если нет pdf-файлов, завершаем программу
    file_list = list(filter(lambda file_ext: file_ext.endswith('.pdf'), file_list))
    if not file_list:
        sys.exit(f'{prog}: error: There are no pdf files in the presented list.')
    # Создаем pdf-файл из file_list
    create_pdf_bookmarks(file_list, file_name_output)
    return


def create_parser(args):
    # Разбираем аргументы args, командной строки. Возвращаем аргументы командной строки, args, без имени программы.
    prog = args[0]
    args = args[1:]
    parser = argparse.ArgumentParser(formatter_class=argparse.RawDescriptionHelpFormatter, description='Converts pdf files into one multi-page document.', epilog='description:\n  -f, --file\tspecifies the file(s) to be merged\n  -d, --dir\tspecifies the directory in which to merge the files\n  -n, --name\tspecifies the name of the output file resulting from\n\t\tconcatenating source files\n\nexamples:\n  pdfmark -d DIR_NAME -n FILENAME_OUTPUT\n\tMerge all files from the directory DIR_NAME into a file FILENAME_OUTPUT.\n  pdfmark -f FILE(s) -n FILENAME_OUTPUT\n\tMerge the specified files into file FILENAME_OUTPUT.')
    # Добавляем необходимые нам ключи.
    parser.add_argument('-f', '--file', nargs='+', type=str, help='set the name of the file(s)')
    parser.add_argument('-d', '--dir', nargs=1, type=str, help='set the name of directory')
    parser.add_argument('-n', '--name', nargs=1, type=str, help='set the name of the output file')
    # Если аргументов нет, выводим справку.
    if len(args) == 0:
        sys.exit(f'usage: {os.path.basename(prog)} [-h]\n{os.path.basename(prog)}: error: no arguments specified: {os.path.basename(prog)}')
    return parser.parse_args(args)


def main(args):
    # Проверяем конфликты ключей командной строки.
    options = create_parser(args)
    if options.dir and options.file or not options.file and not options.dir and options.name:
        sys.exit(f'usage: {os.path.basename(args[0])} [-h | --help].\n{os.path.basename(args[0])}: error: parameters are incorrect')
    # Проверяем ключи и запускаем соответствующие действия.
    else:
        if options.name:
            file_name_output = os.path.splitext(options.name[0])[0] + ".pdf" if not os.path.splitext(options.name[0])[1] else options.name[0]
            if options.file:
                merge_files_list(options.file, file_name_output, os.path.basename(args[0]))
            if options.dir:
                if os.path.isdir(options.dir[0]):
                    merge_files_directories(options.dir[0], file_name_output, os.path.basename(args[0]))
                else:
                    sys.exit(f'{os.path.basename(args[0])}: error: Directory {options.dir[0]} does not exist.')
        else:
            sys.exit(f'usage: {os.path.basename(args[0])} [-h | --help].\n{os.path.basename(args[0])}: error: output file name not specified.')
    return


if __name__ == '__main__':
    sys.exit(main(sys.argv))
