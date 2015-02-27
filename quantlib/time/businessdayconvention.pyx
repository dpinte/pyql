"""
 Copyright (C) 2014, Enthought Inc
 Copyright (C) 2014, Patrick Henaff

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE.  See the license for more details.
"""

from libcpp.string cimport string
from quantlib.util.compat cimport py_string_from_utf8_array
cimport quantlib.time._calendar as _ca

cdef extern from "businessdayconvention_support_code.hpp" namespace "QL":
    string repr(int b) except +


# BusinessDayConvention:
cdef QL_BDC = [_ca.Following, _ca.ModifiedFollowing,
               _ca.Preceding, _ca.ModifiedPreceding,
               _ca.Unadjusted]

_BDC_DICT = {str(BusinessDayConvention(v)).replace(" ",""):v for v in QL_BDC}

cdef class BusinessDayConvention(int):
    __doc__ = 'Valid business day conventions:\n{}'.format(
        '\n'.join(_BDC_DICT.keys())
    )

    def __cinit__(self):
        pass

    @classmethod
    def from_name(cls, name):
        return BusinessDayConvention(_BDC_DICT[name])

    def __str__(self):
        cdef string res = repr(int(self))
        return py_string_from_utf8_array(res.c_str())

    def __repr__(self):
        cdef string res = repr(int(self))
        return 'Business Day Convention: {}'.format(
            py_string_from_utf8_array(res.c_str())
        )
