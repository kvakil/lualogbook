#!/usr/bin/python3
from panflute import *

def demote_header(elem, doc):
    """Demotes headers to prevent first-level headers.

    First-level headers are reserved for daily headers"""
    if isinstance(elem, Header):
        elem.level += 1

def simple_id(filename):
    return ''.join((c for c in filename if c.isdigit()))

def fix_header_id(elem, doc):
    """Prefixes header labels with date to prevent conflicts"""
    if isinstance(elem, Header):
        prefix = simple_id(str(doc.metadata['title']))
        elem.identifier = prefix + ':' + elem.identifier

def combine_filters(*filters):
    """Combines all the filters passed in.""" 
    def combined(elem, doc):
        for f in filters:
            f(elem, doc)
    return combined

def main(doc=None):
    f = combine_filters(demote_header, fix_header_id)
    return run_filter(f, doc=doc)

if __name__ == '__main__':
    main()
