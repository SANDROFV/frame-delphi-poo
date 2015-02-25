unit uSDADataType;

interface

Uses Variants;

const
  IntegerNull  	= low(integer);
  ExtendedNull  	= -900000000;
	StringNull 		= 'NULL';
  TDateTimeNull = 0;
  BlobNull      = 'NULL';
  ClobNull      = 'NULL';

Type
 TSdaParamType = (sdaInteger,sdaFloat, sdaString, sdaDateTime, sdaBlob, sdaclob, sdaBoolean, sdaConcat);
 TOperation = (oCommon, oDelete, oNone);


implementation

end.

