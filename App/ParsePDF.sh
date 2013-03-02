#! /bin/sh
#
# 

# set -x 

# Functions

theTXT=$(echo $2| sed 's/.pdf/.txt/')

/usr/local/bin/pdftotext -raw "$2"

echo "$1" "$2" >> /Users/admin/Dropbox/App/parameters.log

PDF2TEXT="cat $theTXT"

fFact="YYYY-MM-DD"
eFact="concepto"
iFact="00"

## DEBUG
# $PDF2TEXT | awk '/Fecha:/ {print $2}' | head -1 | awk -v FS=. -v a=- '{print $3a$2a$1}'


case $1 in
	plPen_BK) 
		fFact=$($PDF2TEXT | awk '/Fecha:/ {print $2}' | awk -v FS=. -v a=- '{print $3a$2a$1}');
		eFact=$($PDF2TEXT | awk '/EMPLEADOS/ {print "Plan Empleados BK"; exit}');
		iFact=$($PDF2TEXT | awk '/Inscrita/ { print a } { a = $0}');;
	noInt_BK) 
		fFact=$($PDF2TEXT | awk '/Fecha:/ {print $2}' | awk -v FS=. -v a=- '{print $3a$2a$1}');
		eFact=$($PDF2TEXT | awk '/CUENTA CLIENTE/ {print $NF; exit}');
		iFact=$($PDF2TEXT | awk '/IMPORTE TOTAL/ {print $NF;exit}');;
	noOtr_BK) 
		fFact=$($PDF2TEXT | awk '/Fecha:/ {print $2}' | awk -v FS=. -v a=- '{print $3a$2a$1}');
		eFact=$($PDF2TEXT | awk '/NOTIFICACI/ {print $0; exit}'| | tr -d '[:punct:]');
		iFact=$($PDF2TEXT | awk '/Fecha:/ {print "00";exit}');;
	exInt_BK) 
		fFact=$($PDF2TEXT | tr -d "." | awk 'BEGIN{m=split("Ene|Feb|Mar|Abr|May|Jun|Jul|Ago|Sep|Oct|Nov|Dic",d,"|"); for(o=1;o<=m;o++){months[d[o]]=sprintf("%02d",o)}} /Periodo/ {print $NF "-" months[$(NF-1)] "-00"; exit}');
		eFact=$($PDF2TEXT | awk '/Estimado/ {print $3;exit}' | tr -d ":");
		iFact=$($PDF2TEXT | awk '/AHORRO VISTA/ {print $3;exit}' | tr -d ".");;
	exInt_OB) 
		fFact=$($PDF2TEXT | tr -d ' ' | awk '{if ((x=index($0,"-")) > 0) print substr($0,x-2,10)}' | head -1 | awk -v FS=- -v a=- '{print $3a$2a$1}');
		eFact=$($PDF2TEXT | awk '/openbank/ {getline; print $2;exit}');
		iFact=$($PDF2TEXT | awk '/Total Euros/ {getline; getline; getline; getline; getline; print $1;exit}' | tr -d ".");;
	adDom_BK) 
		fFact=$($PDF2TEXT | awk '/Fecha:/ {print $2}' | awk -v FS=. -v a=- '{print $3a$2a$1}');
		eFact=$($PDF2TEXT | awk '/ENTIDAD EMISORA:/ {getline; print $0}' | tr -d ' ');
		iFact=$($PDF2TEXT | awk '/IMPORTE$/ {getline; print $0}' | tr -d ' ');;
	adDom_OB) 
		fFact=$($PDF2TEXT | tr -d ' ' | awk '{if ((x=index($0,"/")) > 0) print substr($0,x-2,10)}' | head -1 | awk -v FS=/ -v a=- '{print $3a$2a$1}');
		eFact=$($PDF2TEXT | tr -d ' ' | awk '/ENTIDAD/ {print substr($0,9,10)}' | head -2 | tail -1);
		iFact=$($PDF2TEXT | awk '/EUR/ {print $1}' | tail -1);;
	exCue_BK) 
		fFact=$($PDF2TEXT | awk '/Fecha:/ {print $2; exit}' | awk -v FS=. -v a=- '{print $3a$2a$1}');
		eFact=$($PDF2TEXT | awk '/CUENTA CLIENTE/ {print $NF; exit}');
		iFact=$($PDF2TEXT | awk '/IMPORTE$/ {getline; print $0}' | tr -d ' ');;
	inPla_BK) 
		fFact=$($PDF2TEXT | awk '/Fecha:/ {print $2; exit}' | awk -v FS=. -v a=- '{print $3a$2a$1}');
		eFact=$($PDF2TEXT | awk '/CUENTA CLIENTE/ {print $NF; exit}');
		iFact=$($PDF2TEXT | awk '/ABONADO EUR:/ {print $4}');;
	tarje_BK) 
		fFact=$($PDF2TEXT | awk '/Fecha:/ {print $2;exit}' | awk -v FS=. -v a=- '{print $3a$2a$1}');
		eFact=$($PDF2TEXT | awk '/^TARJETA/ {print $5}');
		iFact=$($PDF2TEXT | awk '/TOTAL EUROS CONTRATO/ {print $4}');;
	prest_BK) 
		fFact=$($PDF2TEXT | awk '/Fecha:/ {print $2;exit}' | awk -v FS=. -v a=- '{print $3a$2a$1}');
		eFact=$($PDF2TEXT | awk '/CUENTA CLIENTE/ {print $NF; exit}');
		iFact=$($PDF2TEXT | awk '/TOTAL CARGADO/ {print $NF;exit}');;
	trRec_BK) 
		fFact=$($PDF2TEXT | awk '/Fecha:/ {print $2;exit}' | awk -v FS=. -v a=- '{print $3a$2a$1}');
		eFact=$($PDF2TEXT | awk '/ORDENANTE/ {getline; print $1;exit}');
		iFact=$($PDF2TEXT | awk '/IMPORTE ABONADO/ {getline; print $1}');;
	trEmi_BK) 
		fFact=$($PDF2TEXT | awk '/Fecha:/ {print $2}' | awk -v FS=. -v a=- '{print $3a$2a$1}');
		eFact=$($PDF2TEXT | tr -d ' ' | awk '/BENEFICIARIO:/ {print substr($0,14,12)}');
		iFact=$($PDF2TEXT | awk '/TOTAL ADEUDADO EN SU CUENTA EN EUR:/ {print $8}');;
	trRec_OB) 
		fFact=$($PDF2TEXT | awk '/FECHA VALOR/ {getline; print $1}' | awk -v FS=- -v a=- '{print $3a$2a$1}');
		eFact=$($PDF2TEXT | awk '/^ORDENANTE/ {getline; print $1}');
		iFact=$($PDF2TEXT | awk '/IMPORTE RECIBIDO/ {getline; print $1}');;
	trEmi_OB) 
		fFact=$($PDF2TEXT | awk '/FECHA/ {print $2;exit}' | awk -v FS=/ -v a=- '{print $3a$2a$1}');
		eFact=$($PDF2TEXT | awk '/BENEF/ {getline;getline; print $1;exit}');
		iFact=$($PDF2TEXT | awk '/IMPORTE ADEU/ {getline; print $1}');;
	factJazz) 
		#fFact=$($PDF2TEXT | awk '/20/ {if (NF==3) print $0}');
		fFact=$($PDF2TEXT | awk 'BEGIN{m=split("Enero|Febrero|Marzo|Abril|Mayo|Junio|Julio|Agosto|Septiembre|Octubre|Noviembre|Diciembre",d,"|"); for(o=1;o<=m;o++){months[d[o]]=sprintf("%02d",o)}} /20/ {if (NF==3) print $NF "-" months[$(NF-1)] "-" $(NF-2)}' |grep -v 2038| head -1);
		#fFact=$($PDF2TEXT | awk 'BEGIN{m=split("Enero|Febrero|Marzo|Abril|Mayo|Junio|Julio|Agosto|Septiembre|Octubre|Noviembre|Diciembre",d,"|"); for(o=1;o<=m;o++){months[d[o]]=sprintf("%02d",o)}} /Fecha de factura/ {print $NF "-" months[$(NF-1)] "-" $(NF-2)}' |grep -v 2038| head -1);
		eFact="jazztel";	
		#iFact=$($PDF2TEXT | awk '/Total a pagar/ {getline; print $1}' | tr -d ".");;		
		iFact=$($PDF2TEXT | awk '/Total a pagar/ {print $4}' | tr -d ".");;		
	factGas) 
		fFact=$($PDF2TEXT | awk 'BEGIN{m=split("enero|febrero|marzo|abril|mayo|junio|julio|agosto|septiembre|octubre|noviembre|diciembre",d,"|"); for(o=1;o<=m;o++){months[d[o]]=sprintf("%02d",o)}} /Fecha factura/ {printf "%04d-%02d-%02d", $7, months[tolower($5)], $3}' | head -1);
		eFact="iberdrola";	
		iFact=$($PDF2TEXT | awk '/IMPORTE FACTURA/ {print $NF; exit}' | tr -d ".");;		
	factElec) 
		fFact=$($PDF2TEXT | awk 'BEGIN{m=split("enero|febrero|marzo|abril|mayo|junio|julio|agosto|septiembre|octubre|noviembre|diciembre",d,"|"); for(o=1;o<=m;o++){months[d[o]]=sprintf("%02d",o)}} /Fecha factura/ {printf "%04d-%02d-%02d", $7, months[tolower($5)], $3}' | head -1);
		eFact="iberdrola";	
		iFact=$($PDF2TEXT | awk '/IMPORTE FACTURA/ {print $NF; exit}' | tr -d ".");;		
	factAgua) 
		fFact=$($PDF2TEXT | tr -d ' ' | awk '/FechaLectura/ {getline; print substr($0,10,10); exit}'| awk -v FS=- '{printf "%04d-%02d-%02d", $3, $2, $1}');
		eFact="canalisabelii";	
		iFact=$($PDF2TEXT | tr -d ' ' | awk '/totalapagar/ {getline;getline;getline;getline;print $1}' |tail -1 | tr -d ".");;		
	factMovi) 
		fFact=$($PDF2TEXT | tr -d "." | awk 'BEGIN{m=split("ene|feb|mar|abr|may|jun|jul|ago|sep|oct|nov|die",d,"|"); for(o=1;o<=m;o++){months[d[o]]=sprintf("%02d",o)}} /Madrid/ {printf "20%02d-%02d-%02d", $4, months[tolower($3)], $2; exit}');
		#fFact=$($PDF2TEXT | tr -d "." | awk 'BEGIN{m=split("ene|feb|mar|abr|may|jun|jul|ago|sep|oct|nov|die",d,"|"); for(o=1;o<=m;o++){months[d[o]]=sprintf("%02d",o)}} /Fecha/ {printf "20%02d-%02d-%02d", $4, months[tolower($3)], $2; exit}');
		eFact=$($PDF2TEXT | awk '/fono/ {print $2;exit}');
		iFact=$($PDF2TEXT | awk 'tolower($0) ~ /total a pagar/ {getline;getline;getline;getline;print $1}'| tr -d ".");;		
		#iFact=$($PDF2TEXT | awk 'tolower($0) ~ /total a pagar/ {print $5}'| tr -d ".");;		
	factAuna) 
		fFact=$($PDF2TEXT | tr -d "." | awk 'BEGIN{m=split("ene|feb|mar|abr|may|jun|jul|ago|sep|oct|nov|die",d,"|"); for(o=1;o<=m;o++){months[d[o]]=sprintf("%02d",o)}} /Madrid/ {printf "20%02d-%02d-%02d", $4, months[tolower($3)], $2; exit}');
		eFact=$($PDF2TEXT | awk '/fono:/ {print $2;exit}');
		iFact=$($PDF2TEXT | awk 'tolower($0) ~ /total a pagar/ {getline;getline;getline;getline;print $1}'| tr -d ".");;		
esac

if [ "$fFact" = " - - " ]; then
    fFact="YYYY-MM-DD"
fi
if [ "$eFact" = "" ]; then
    eFact="concepto"
fi
if [ "$iFact" = "" ]; then
    iFact="00"
fi

fFact0=$(echo $fFact | sed 's/A/0/')

#rm -f $theTXT

echo "$fFact0 - $eFact - $iFact"
