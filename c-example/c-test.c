#include <stdio.h>
#include "../cdbfapi-plus/cdbfapiPlusX.h"


int
main()
{
    int i, j;

    cdbfapiPlus *dbf = cdbfapiCreate();
    if (!dbf) return 1; 

    if (openDBFfile(dbf, "example.dbf"))
    {
        printf("RecCount: = %d | FieldCount = %d | RecordLength = %d\n",
			recCount(dbf), fieldCount(dbf), recordLength(dbf));

		setDateFormat(dbf, "dmy");

		for(j = 0; j < fieldCount(dbf); j++)
		{
			printf("%s %c(%d.%d)\n", fieldName(dbf, j), fieldType(dbf, j), fieldLength(dbf, j), fieldDecimal(dbf, j));
		}
		printf("\n");

        for(i = 0; i < recCount(dbf); i++)
		{
			readRecord(dbf, i);

			for(j = 0; j < fieldCount(dbf); j++)
			{
				char *s = getString(dbf, j);
				printf("%s|", s);
            }
			printf("\n");
		}

        closeDBFfile(dbf);
    }

    cdbfapiRelease(dbf);

    getchar();

    return 0;
}