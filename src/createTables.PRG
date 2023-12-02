CREATE TABLE FAC ( ;
	fptoven numeric(5), ;
	fletra character(1), ;
	fnumcomp numeric(8), ;
	ffecha date, ;
	fcodcli character(15), ;
	ftotal numeric(15,2) ;
)

CREATE TABLE FACDET ( ;
	fptoven numeric(5), ;
	fletra character(1), ;
	fnumcomp numeric(8), ;
	fcodart character(10), ;
	fdesart character(25), ;
	fcant numeric(15,2), ;
	fprecuni numeric(15,2), ;
	faliciva numeric(5,2), ;
	fmonto numeric(15,2) ;
)

USE IN ("FAC")
USE IN ("FACDET")