# User Data Acquisition Checklist

This file records only datasets for which user action, account access, institutional approval, or a license may be required. Public datasets that can be scripted directly are handled separately.

## Priority 1: IPUMS USA

Official extract page:
https://usa.ipums.org/usa/data.shtml

Select samples:
- 1990 5% State sample
- 2000 5% sample
- ACS 1-year samples for every year 2005 through the latest available year

Core variables:
- YEAR
- SAMPLE
- SERIAL
- PERNUM
- PERWT
- AGE
- SEX
- RACE
- HISPAN
- EDUC
- EDUCD
- EMPSTAT
- EMPSTATD
- LABFORCE
- OCC
- OCC1990
- OCC2010
- OCCSOC
- IND
- IND1990
- INDNAICS
- CLASSWKR
- CLASSWKRD
- INCWAGE
- INCTOT
- UHRSWORK
- WKSWORK2
- WORKEDYR
- STATEFIP
- PUMA
- MET2013
- METAREA
- PWPUMA00 where available
- PWPUMA where available
- MIGRATE1
- MIGPUMA1
- MIGPLAC1

Download and provide:
- compressed data file (.dat.gz)
- DDI/XML codebook (.xml)
- R syntax file if offered
- extract description/codebook PDF or text if offered

Do not decompress before sharing.

## Priority 2: IPUMS International

Official site:
https://international.ipums.org/international/

Initial core-country sample set:
- Argentina: 1980, 1991, 2001, 2010
- Brazil: 1980, 1991, 2000, 2010
- Chile: 1982, 1992, 2002, 2017
- Costa Rica: 1984, 2000, 2011
- Mexico: 1990, 2000, 2010, 2020
- South Africa: 1996, 2001, 2011, 2016
- Ghana: 1984, 2000, 2010 where variables permit
- Kenya: 1989, 1999, 2009, 2019
- Bangladesh: 1991, 2001, 2011
- Indonesia: 1980, 1990, 2000, 2010
- Vietnam: 1989, 1999, 2009, 2019

Core variables:
- SAMPLE
- COUNTRY
- YEAR
- PERWT
- AGE
- SEX
- EDATTAIN
- YRSCHOOL where available
- EMPSTAT
- CLASSWK
- OCC
- OCCISCO
- IND
- INDGEN
- GEOLEV1
- GEOLEV2
- URBAN

Income supplement where available:
- INCTOT
- country-specific earnings variables if necessary

Download and provide:
- .dat.gz data
- XML/DDI codebook
- R syntax file
- extract description

If the full extract is too large, split by region or country group without changing variables.

## Priority 3: Eurostat EU-LFS Scientific Use Files

Access page:
https://ec.europa.eu/eurostat/web/microdata/access

Collection:
EU Labour Force Survey scientific-use microdata, full available time series.

Desired scope:
- all available countries
- 1983 through latest accessible year
- person weights
- occupation
- industry
- employment status
- class of worker
- age
- sex
- education
- NUTS region
- earnings/pay variables where available

This access requires an eligible recognized research entity and an approved research proposal.

Do not upload restricted files to this project unless the access terms explicitly permit it. If files must stay in the approved environment, use repository analysis scripts there and export only permitted statistical outputs.

## Priority 4: UK Annual Population Survey Secure Access

UK Data Service study:
SN 6721, Annual Population Survey, 2004-2026: Secure Access.

Desired variables:
- occupation
- industry
- employment status
- earnings
- hours
- age
- education
- worker status
- local authority / detailed workplace geography where permitted
- weights
- longitudinal identifiers where available

This is a Secure Access dataset. Use only inside the approved UK Data Service environment and export disclosure-checked results.

## Priority 5: Lightcast global job postings

Academic research information:
https://lightcast.io/resources/academic-research

Request:
global historical job-posting microdata, ideally 2015 through latest available date.

Minimum fields:
- posting ID
- posting date
- expiration date
- occupation
- title
- employer/company
- country
- region
- county/local geography where available
- remote status
- seniority/experience
- skills
- salary where present
- education requirements
- employment type
- posting text if license permits

Preferred countries:
United States, United Kingdom, Canada, Australia, India, Brazil, major EU economies, plus as broad a global panel as the license allows.

## Priority 6: Revelio Labs

Research page:
https://www.reveliolabs.com/products/research

Request:
academic/institutional workforce data, ideally 2008 through latest available date.

Desired:
- job histories
- occupation/title
- employer
- location
- start/end dates
- seniority
- compensation estimates where available
- hiring/separation events
- job postings if included
- skills

Revelio notes academic/institutional access can be available through WRDS or one-time research projects.

## Optional high-value collaboration

Upwork or another large freelance platform.

Desired fields:
- posting time and category
- client geography
- freelancer geography
- bids
- bid amount
- contract award
- contract type
- final price
- completion time
- worker history and prior earnings rank
- AI-tool access/adoption where observed

This would directly test the AI second-shock mechanism in a market where work is already digitally tradable.

## Public datasets handled by the project without user action

- BLS OEWS historical metro/state/national files, 1997 onward
- O*NET historical releases, especially 4.0 and 5.0
- NTIA BTOP/BIP applications, awards, service areas and archived program documents
- Census County Business Patterns
- Census Nonemployer Statistics
- BLS QCEW
- U.S. QWI/BDS where useful
- India PLFS public-use unit data
- Brazil RAIS public non-identified microdata
- Ofcom Connected Nations broadband data
- BDUK intervention/open-market-review data
- public geographic crosswalks and shapefiles
- global macro internet-adoption indicators for descriptive validation

## Transfer

For ordinary files that licensing permits sharing:
- attach directly in ChatGPT if practical, or
- place in a Google Drive folder and send the file/folder link in the conversation.

Always preserve original compressed files and accompanying documentation.
