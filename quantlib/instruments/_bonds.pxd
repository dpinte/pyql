include '../types.pxi'

from libcpp.vector cimport vector
from libcpp cimport bool

from quantlib.handle cimport shared_ptr, Handle
from _instrument cimport Instrument
from quantlib.time._calendar cimport BusinessDayConvention, Calendar
from quantlib.time._date cimport Date
from quantlib.time._daycounter cimport DayCounter
from quantlib.time._schedule cimport Schedule
from quantlib._cashflow cimport Leg

cdef extern from 'ql/instruments/bond.hpp' namespace 'QuantLib':
    cdef cppclass Bond(Instrument):

        bool isExpired()
        Natural settlementDays()
        Calendar& calendar()
        vector[Real]& notionals()
        Real notional(Date d)
        Leg cashflows()
        Date maturityDate()
        Date issueDate()
        Date settlementDate()
        Date settlementDate(Date d)
        bool isTradable(Date d)
        Real accruedAmount() except +
        Real accruedAmount(Date d) except +


        Real cleanPrice()
        Real dirtyPrice()
        Real settlementValue()

        Date nextCachFlowDate(Date d)
        Date previousCachFlowDate(Date d)

cdef extern from 'ql/instruments/bonds/fixedratebond.hpp' namespace 'QuantLib':
    cdef cppclass FixedRateBond(Bond):
        FixedRateBond(Natural settlementDays,
                      Real faceAmount,
                      Schedule& schedule,
                      vector[Rate]& coupons,
                      DayCounter& accrualDayCounter,
                      BusinessDayConvention paymentConvention,
                      Real redemption)
        FixedRateBond(Natural settlementDays,
                      Real faceAmount,
                      Schedule& schedule,
                      vector[Rate]& coupons,
                      DayCounter& accrualDayCounter,
                      BusinessDayConvention paymentConvention,
                      Real redemption,
                      Date& issueDate)
        Date settlementDate()

cdef extern from 'ql/instruments/bonds/zerocouponbond.hpp' namespace 'QuantLib':
    cdef cppclass ZeroCouponBond(Bond):
        ZeroCouponBond(Natural settlementDays,
                      Calendar calendar,
                      Real faceAmount,
                      Date maturityDate,
                      BusinessDayConvention paymentConvention,
                      Real redemption,
                      Date& issueDate)
