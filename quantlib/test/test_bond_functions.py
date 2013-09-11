import unittest

from quantlib.instruments.bonds import FixedRateBond
from quantlib.pricingengines import bond_functions as bnd_func
from quantlib.settings import Settings
from quantlib.time.api import (
    Date, TARGET, February, August, Following, Schedule, Jul, Years,
    Unadjusted, Period, Annual, ModifiedFollowing, Backward, ActualActual,
    ISMA
)

class BondFunctionsTestCase(unittest.TestCase):

  def test_start_date(self):

        todays_date = Date(25, August, 2011)

        settings = Settings()
        settings.evaluation_date =  todays_date

        calendar = TARGET()
        effective_date = Date(10, Jul, 2006)
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
        bond = FixedRateBond(
            settlement_days,
		    face_amount,
		    fixed_bond_schedule,
		    [coupon_rate],
            ActualActual(ISMA),
		    Following,
            redemption,
            issue_date
        )

        self.assertEquals(bnd_func.start_date(bond), effective_date)
        self.assertEquals(bnd_func.maturity_date(bond), Date(11, 7, 2016))

