import unittest

from quantlib.compounding import Compounded, Continuous
from quantlib.instruments.bonds import FixedRateBond
from quantlib.pricingengines import bond_functions as bnd_func
from quantlib.settings import Settings
from quantlib.time.api import (
    Date, TARGET, August, Following, Schedule, Jul, Years,
    Unadjusted, Period, Annual, ModifiedFollowing, Backward, ActualActual,
    ISMA, NullCalendar, Actual365Fixed
)
from quantlib.termstructures.yields.api import FlatForward

class BondFunctionsTestCase(unittest.TestCase):

    def setUp(self):

        todays_date = Date(25, August, 2011)

        settings = Settings()
        settings.evaluation_date =  todays_date

        calendar = TARGET()
        self.effective_date = effective_date = Date(10, Jul, 2006)
        termination_date = calendar.advance(
            effective_date, 10, Years, convention=Unadjusted
        )


        settlement_days = 3
        face_amount = 100.0
        coupon_rate = 0.05
        redemption = 100.0
        fixed_bond_schedule = Schedule(
            effective_date,
            termination_date,
            Period(Annual),
            calendar,
            ModifiedFollowing,
            ModifiedFollowing,
            Backward
        )

        issue_date = effective_date
        self.bond = FixedRateBond(
            settlement_days, face_amount, fixed_bond_schedule,
            [coupon_rate], ActualActual(ISMA), Following, redemption,
            issue_date
        )

    def test_date_methods(self):

        self.assertEquals(bnd_func.start_date(self.bond), self.effective_date)
        self.assertEquals(bnd_func.maturity_date(self.bond), Date(11, 7, 2016))


    def test_price_methods(self):

        flat_term_structure = FlatForward(
           settlement_days=1, forward=0.044, calendar=NullCalendar(),
            daycounter=Actual365Fixed(), compounding = Continuous,
            frequency=Annual
        )

        self.assertAlmostEquals(
            bnd_func.clean_price(self.bond, flat_term_structure),
            102.1154, 4
        )

