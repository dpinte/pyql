import numpy as np

from ..compounding import Continuous
from ..instruments.bonds import FixedRateBond
from ..pricingengines.bond import DiscountingBondEngine
from ..time.api import (
    ActualActual, Schedule, TARGET, Period, Semiannual, Bond, Following,
    NullCalendar, Actual360, ISDA, NullCalendar, Unadjusted
)
from ..termstructures.yields.api import FlatForward, YieldTermStructure

def bond_price(yields, coupon_rate, settlement_date, maturity_date,
               period=Semiannual, day_counter=None, face_amount=100.,
               issue_date=None):
    """ Price a fixed income security from yield to maturity.

    :param yield: Bond yield to maturity is on a semiannual basis for basis
        values 0 through 7 and an annual basis for basis values 8 through 12.
    :param coupon_rate: Decimal number indicating the annual percentage rate
        used to determine the coupons payable on a bond.
    :param settlement_date: Settlement date.
    :param maturity_date: Maturity date.
    :param period: coupons per year for the bond. Defaults to Semiannual
    :param day_counter: day-count basis of the instrument. Defauts to
        Actual360
    """

    if settlement_date > maturity_date:
        raise ValueError('Settlement date must be earlier than maturity date.')

    if day_counter is None:
        day_counter = ActualActual(ISDA)

    settlement_days = 0

    calendar = TARGET()

    redemption = face_amount

    bond = FixedRateBond(
        settlement_days, face_amount, fixed_bonds_schedule=None,
        coupons=[coupon_rate],
        accrual_day_counter=day_counter, payment_convention=Unadjusted,
        redemption=redemption, issue_date=issue_date, coupon_calendar=calendar,
        start_date=settlement_date, maturity_date=maturity_date,
        period=Period(period))

    discounting_term_structure = YieldTermStructure(relinkable=True)

    print 'Create discouting engine'
    engine = DiscountingBondEngine(discounting_term_structure)

    print 'Set pricing engine'
    bond.set_pricing_engine(engine)

    if np.isscalar(yields):
        yields = np.atleast_1d(yields)

    output_price = np.empty_like(yields)
    output_accrued_interest = np.empty_like(yields)

    print yields
    for i in xrange(len(yields)):
        flat_term_structure = FlatForward(
            forward         = yields[i],
            calendar        = calendar,
            daycounter      = day_counter,
            #compounding     = Continuous,
            #frequency       = period
        )
        print 'Link to ...'
        print flat_term_structure.discount(10.0)
        discounting_term_structure.link_to(flat_term_structure)
        print discounting_term_structure.discount(10.0)

        output_price[i] = bond.clean_price
        output_accrued_interest[i] = bond.accrued_amount(settlement_date)


    return output_price, output_accrued_interest



