"""
 Copyright (C) 2011, Enthought Inc

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE.  See the license for more details.
"""
# distutils: language = c++

include '../types.pxi'


from libcpp cimport bool

from quantlib.instruments._bonds cimport Bond
from quantlib.time._date cimport Date
from quantlib.pricingengines._pricing_engine cimport PricingEngine
from quantlib.handle cimport Handle
from quantlib.termstructures._yield_term_structure cimport YieldTermStructure

cdef extern from 'boost/optional.hpp' namespace 'boost':
    cdef cppclass optional[T]:
        optional(T*)

cdef extern from 'ql/pricingengines/bond/discountingbondengine.hpp' namespace \
    'QuantLib':

    cdef cppclass DiscountingBondEngine(PricingEngine):

        DiscountingBondEngine()
        DiscountingBondEngine(Handle[YieldTermStructure]& discountCurve)
        DiscountingBondEngine(Handle[YieldTermStructure]& discountCurve,
                optional[bool] includeSttlementDateFlows)


cdef extern from 'ql/pricingengines/bond/bondfunctions.hpp' namespace 'QuantLib::BondFunctions':

    # QuantLib::BondFunctions static methods
    #cdef Date startDate 'QuantLib::BondFunctions::startDate'(Bond& bond)
    cdef Date startDate(Bond& bond)
    cdef Date maturityDate(Bond& bond)
    cdef Real cleanPrice(Bond& bond, YieldTermStructure& discountCurve)
    cdef Real cleanPrice(Bond& bond, YieldTermStructure& discountCurve,
                         Date settlementDate)


