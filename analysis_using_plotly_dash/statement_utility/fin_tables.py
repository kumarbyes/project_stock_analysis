from sqlalchemy import create_engine, MetaData,Table,Column, Integer, String,text,select
from sqlalchemy.orm import Session
from sqlalchemy.orm import DeclarativeBase
from sqlalchemy.orm import Mapped
from sqlalchemy.orm import mapped_column
from sqlalchemy import and_
from sqlalchemy import func,desc,asc
from sqlalchemy import cast, Numeric,Float
import urllib.parse

with open("../querying_using_sqlalchemy/db_password.txt") as file:
    db_pw = file.read()

db_pw = db_pw.strip()

encoded_pw = urllib.parse.quote_plus(db_pw)
url = f"postgresql://postgres:{encoded_pw}@localhost:5432/postgres"
engine = create_engine(url)

# declarative base class
class Base(DeclarativeBase):
    pass

# Load the "Parent" first
class BalanceSheetTable(Base):
    __tablename__ = "balance_sheet"
    __table_args__ = {"autoload_with": engine, "schema": "alpha_vantage_db"}

# Then load the "Children"
class IncomeStatementTable(Base):
    __tablename__ = "income_statement"
    __table_args__ = {"autoload_with": engine, "schema": "alpha_vantage_db"}

class CashFlowTable(Base):
    __tablename__ = "cash_flow"
    __table_args__ = {"autoload_with": engine, "schema": "alpha_vantage_db"}

class SharesOutstanding(Base):
    __tablename__ = "shares_outstanding"
    __table_args__ = {"autoload_with": engine, "schema": "alpha_vantage_db"}

class Splits(Base):
    __tablename__ = "splits"
    __table_args__ = {"autoload_with": engine, "schema": "alpha_vantage_db"}

class Dividends(Base):
    __tablename__ = "dividends"
    __table_args__ = {"autoload_with": engine, "schema": "alpha_vantage_db"}

class Earnings(Base):
    __tablename__ = "earnings"
    __table_args__ = {"autoload_with": engine, "schema": "alpha_vantage_db"}

class EarningsEstimates(Base):
    __tablename__ = "earnings_estimates"
    __table_args__ = {"autoload_with": engine, "schema": "alpha_vantage_db"}

class Overview(Base):
    __tablename__ = "overview"
    __table_args__ = {"autoload_with": engine, "schema": "alpha_vantage_db"}

class Stock(Base):
    __tablename__ = "stock"
    __table_args__ = {"autoload_with": engine, "schema": "alpha_vantage_db"}

class Currency(Base):
    __tablename__ = "currency"
    __table_args__ = {"autoload_with": engine, "schema": "alpha_vantage_db"}

class OHLCV(Base):
    __tablename__ = "ohlcv"
    __table_args__ = {"autoload_with": engine, "schema": "alpha_vantage_db"}