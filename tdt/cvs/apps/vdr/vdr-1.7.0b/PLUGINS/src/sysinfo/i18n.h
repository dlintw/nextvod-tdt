#ifndef ___I18N_H
#define ___I18N_H

#include <vdr/i18n.h>
#ifndef VDRVERSNUM
#include <vdr/config.h>
#endif

extern const char *i18n_name;
extern const tI18nPhrase Phrases[];

#undef tr
#define tr(s)  I18nTranslate(s, i18n_name)

const char *i18n_name = 0;

const tI18nPhrase Phrases[] = {
   {"SysInfo",							//English
	"",									// Deutsch
	"",									// Slovenski
	"Informazioni sul sistema",			// Italiano
	"", 								// Nederlands
	"", 								// Português
	"", 								// Français
	"", 								// Norsk
	"", 								// Suomi
	"", 								// Polski
	"", 								// Español
	"", 								// Ellinika
	"", 								// Svenska
	"", 								// Romaneste
	"",									//
	"",									//
	"", 								// Russian
	"",									//
   },
   {"System information plugin",		//English
	"",									// Deutsch
	"",									// Slovenski
	"Plugin informazioni sul sistema",	// Italiano
	"", 								// Nederlands
	"", 								// Português
	"", 								// Français
	"", 								// Norsk
	"", 								// Suomi
	"", 								// Polski
	"", 								// Español
	"", 								// Ellinika
	"", 								// Svenska
	"", 								// Romaneste
	"",									//
	"",									//
	"", 								// Russian
	"",									//
   },   
   {"Total memory:",					//English
	"",									// Deutsch
	"",									// Slovenski
	"Memoria totale:",					// Italiano
	"", 								// Nederlands
	"", 								// Português
	"", 								// Français
	"", 								// Norsk
	"", 								// Suomi
	"", 								// Polski
	"", 								// Español
	"", 								// Ellinika
	"", 								// Svenska
	"", 								// Romaneste
	"",									//
	"",									//
	"", 								// Russian
	"",									//
   },  
   {"PLEASE WAIT...",					//English
	"",									// Deutsch
	"",									// Slovenski
	"ATTENDERE PREGO...",				// Italiano
	"", 								// Nederlands
	"", 								// Português
	"", 								// Français
	"", 								// Norsk
	"", 								// Suomi
	"", 								// Polski
	"", 								// Español
	"", 								// Ellinika
	"", 								// Svenska
	"", 								// Romaneste
	"",									//
	"",									//
	"", 								// Russian
	"",									//
   },  
   {"Cpu temperature:",					//English
	"",									// Deutsch
	"",									// Slovenski
	"Temperatura cpu:",					// Italiano
	"", 								// Nederlands
	"", 								// Português
	"", 								// Français
	"", 								// Norsk
	"", 								// Suomi
	"", 								// Polski
	"", 								// Español
	"", 								// Ellinika
	"", 								// Svenska
	"", 								// Romaneste
	"",									//
	"",									//
	"", 								// Russian
	"",									//
   },    
   {"M/B temperature:",					//English
	"",									// Deutsch
	"",									// Slovenski
	"Temperatura della M/B:",			// Italiano
	"", 								// Nederlands
	"", 								// Português
	"", 								// Français
	"", 								// Norsk
	"", 								// Suomi
	"", 								// Polski
	"", 								// Español
	"", 								// Ellinika
	"", 								// Svenska
	"", 								// Romaneste
	"",									//
	"",									//
	"", 								// Russian
	"",									//
   }, 
   {"Fan1:",							//English
	"",									// Deutsch
	"",									// Slovenski
	"Giri ventola 1:",					// Italiano
	"", 								// Nederlands
	"", 								// Português
	"", 								// Français
	"", 								// Norsk
	"", 								// Suomi
	"", 								// Polski
	"", 								// Español
	"", 								// Ellinika
	"", 								// Svenska
	"", 								// Romaneste
	"",									//
	"",									//
	"", 								// Russian
	"",									//
   },
   {"Fan2:",							//English
	"",									// Deutsch
	"",									// Slovenski
	"Giri ventola 2:",	// Italiano
	"", 								// Nederlands
	"", 								// Português
	"", 								// Français
	"", 								// Norsk
	"", 								// Suomi
	"", 								// Polski
	"", 								// Español
	"", 								// Ellinika
	"", 								// Svenska
	"", 								// Romaneste
	"",									//
	"",									//
	"", 								// Russian
	"",									//
   },
   {"Video disk free space:",			//English
	"",									// Deutsch
	"",									// Slovenski
	"Spazio libero disco video:",		// Italiano
	"", 								// Nederlands
	"", 								// Português
	"", 								// Français
	"", 								// Norsk
	"", 								// Suomi
	"", 								// Polski
	"", 								// Español
	"", 								// Ellinika
	"", 								// Svenska
	"", 								// Romaneste
	"",									//
	"",									//
	"", 								// Russian
	"",									//
   },
   {"Linux kernel:",					//English
	"",									// Deutsch
	"",									// Slovenski
	"Kernel linux:",					// Italiano
	"", 								// Nederlands
	"", 								// Português
	"", 								// Français
	"", 								// Norsk
	"", 								// Suomi
	"", 								// Polski
	"", 								// Español
	"", 								// Ellinika
	"", 								// Svenska
	"", 								// Romaneste
	"",									//
	"",									//
	"", 								// Russian
	"",									//
   },
   {"Cpu type:",							//English
	"",									// Deutsch
	"",									// Slovenski
	"Tipo cpu:",						// Italiano
	"", 								// Nederlands
	"", 								// Português
	"", 								// Français
	"", 								// Norsk
	"", 								// Suomi
	"", 								// Polski
	"", 								// Español
	"", 								// Ellinika
	"", 								// Svenska
	"", 								// Romaneste
	"",									//
	"",									//
	"", 								// Russian
	"",									//
   },
   {"Cpu speed:",						//English
	"",									// Deutsch
	"",									// Slovenski
	"Velocità cpu:",					// Italiano
	"", 								// Nederlands
	"", 								// Português
	"", 								// Français
	"", 								// Norsk
	"", 								// Suomi
	"", 								// Polski
	"", 								// Español
	"", 								// Ellinika
	"", 								// Svenska
	"", 								// Romaneste
	"",									//
	"",									//
	"", 								// Russian
	"",									//
   },
   {"Cpu used:",						//English
	"",									// Deutsch
	"",									// Slovenski
	"Cpu utilizzata:",					// Italiano
	"", 								// Nederlands
	"", 								// Português
	"", 								// Français
	"", 								// Norsk
	"", 								// Suomi
	"", 								// Polski
	"", 								// Español
	"", 								// Ellinika
	"", 								// Svenska
	"", 								// Romaneste
	"",									//
	"",									//
	"", 								// Russian
	"",									//
   },
   {"Cpu free:",						//English
	"",									// Deutsch
	"",									// Slovenski
	"Cpu libera:",						// Italiano
	"", 								// Nederlands
	"", 								// Português
	"", 								// Français
	"", 								// Norsk
	"", 								// Suomi
	"", 								// Polski
	"", 								// Español
	"", 								// Ellinika
	"", 								// Svenska
	"", 								// Romaneste
	"",									//
	"",									//
	"", 								// Russian
	"",									//
   },
   {"Used memory:",						//English
	"",									// Deutsch
	"",									// Slovenski
	"Memoria utilizzata:",				// Italiano
	"", 								// Nederlands
	"", 								// Português
	"", 								// Français
	"", 								// Norsk
	"", 								// Suomi
	"", 								// Polski
	"", 								// Español
	"", 								// Ellinika
	"", 								// Svenska
	"", 								// Romaneste
	"",									//
	"",									//
	"", 								// Russian
	"",									//
   },
   {"Free memory:",						//English
	"",									// Deutsch
	"",									// Slovenski
	"Memoria libera:",					// Italiano
	"", 								// Nederlands
	"", 								// Português
	"", 								// Français
	"", 								// Norsk
	"", 								// Suomi
	"", 								// Polski
	"", 								// Español
	"", 								// Ellinika
	"", 								// Svenska
	"", 								// Romaneste
	"",									//
	"",									//
	"", 								// Russian
	"",									//
   },
 { NULL }
};

#endif //___I18N_H
