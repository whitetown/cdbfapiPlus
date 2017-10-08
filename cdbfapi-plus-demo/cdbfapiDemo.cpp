// cdbfapiDemo.cpp : Defines the entry point for the console application.
//

#include <stdio.h>
#include "stdafx.h"
#include "../cdbfapi-plus/cdbfapiplus.h"

int main(int argc, char* argv[])
{
	cdbfapiPlus demo;
    cdbfapiPlus *dbf = new cdbfapiPlus();

	printf("CDBFAPI Demo %s\n", argv[0]);
	printf("CDBFAPI object %p\n", &demo);

	char filename[MAX_PATH];
	strcpy(filename, argv[0]);
	char *endOfPath = strrchr(filename, '\\');
	if (endOfPath) *endOfPath='\0';
	strcat(filename, "\\example.dbf");

	printf("Filename %s\n", filename);

    demo.initLibrary(0 , "test@example.com");
    dbf->initLibrary(0 , "test@example.com");

    if (dbf->openDBFfile(filename))
        printf("OK\n");

    delete(dbf);

	if (demo.openDBFfile(filename))
	{
		printf("Reccount: = %d | FieldCount = %d | RecordLength = %d\n",
			demo.recCount(), demo.fieldCount(), demo.recordLength());

		demo.setDateFormat("dmy");

		for(int j = 0; j < demo.fieldCount(); j++)
		{
			printf("%s %c(%d.%d)\n", demo.fieldName(j), demo.fieldType(j), demo.fieldLength(j), demo.fieldDecimal(j));
		}
		printf("\n");

		for(int i = 0; i < demo.recCount(); i++)
		{
			demo.readRecord(i);

			for(int j = 0; j < demo.fieldCount(); j++)
			{
				char *s = demo.getString(j);
				printf("%s|", s);
                /*
                if (demo.fieldType(j) == 'D')
                {
                    struct tm t   = demo.getDateTime(j);
                    __int64 ticks = demo.getTicks(j);
                    printf("\n%s %ld", asctime(&t), ticks);
	                getchar();
                }
                */		
            }
			printf("\n");
		}

		demo.closeDBFfile();
	}

	printf("Press Enter to finish\n");

	getchar();

	return 0;
}

