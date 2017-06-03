from panflute import *

def my_filter(elem, doc):
    # demotes headers to prevent first-level headers
    if isinstance(elem, Header):
        elem.level += 1

def main(doc=None):
    return run_filter(my_filter, doc=doc)

if __name__ == '__main__':
    main()
