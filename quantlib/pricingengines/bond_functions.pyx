"""
 Copyright (C) 2011, Enthought Inc

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE.  See the license for more details.
"""
# distutils: language = c++
from cython.operator cimport dereference as deref

cimport _bond

from quantlib.instruments.bonds cimport Bond
from quantlib.time.date cimport date_from_qldate, Date
from quantlib.termstructures.yields.yield_term_structure cimport YieldTermStructure


def start_date(Bond bond):

    cdef _bond.Bond* qlbond = <_bond.Bond*>bond._thisptr.get()
    cdef _bond.Date dt = _bond.startDate(deref(qlbond))

    cdef Date date = date_from_qldate(dt)

    return date

def maturity_date(Bond bond):

    cdef _bond.Bond* qlbond = <_bond.Bond*>bond._thisptr.get()
    cdef _bond.Date dt = _bond.maturityDate(deref(qlbond))

    cdef Date date = date_from_qldate(dt)

    return date

def clean_price(Bond bond, YieldTermStructure yts, Date settlement_date=None):
    cdef _bond.Bond* qlbond = <_bond.Bond*>bond._thisptr.get()

    if settlement_date is not None:
        result = _bond.cleanPrice(
            deref(qlbond), deref(yts._thisptr.get()),
            deref(settlement_date._thisptr.get())
        )
    else:
        result = _bond.cleanPrice(
            deref(qlbond), deref(yts._thisptr.get())
        )

    return result

