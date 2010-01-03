/*
 * admin.c: A plugin for the Video Disk Recorder
 *
 * See the README file for copyright information and how to reach the author.
 *
 */

#include <getopt.h>
#include <stdlib.h>
#include <vdr/interface.h>
#include <vdr/plugin.h>
#include <vdr/menu.h>
#include <vdr/skins.h>

#define MAX_ENTRIES 1024
#define MAX_LISTITEMS 32
#define MAX_GROUPS  20

#define STATE_GROUPS     1000
#define STATE_SAVEEXIT    999
#define STATE_SAVEBACK    998
#define STATE_NOSAVEBACK  997

#define LOW_CHARS   "abcdefghijklmnopqrstuvwxyz"
#define UP_CHARS    "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
#define NUM_CHARS   "0123456789"
#define FNAME_CHARS " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-.#~,/_@"
#define SETUP_MAINMENUENTRY       "MenuEntry"

static const char *VERSION        = "0.8.0";
static const char *DESCRIPTION    = tr("Administrative tasks");
static const char *MAINMENUENTRY  = tr("Administrative tasks");

int mainMenuEntry = 0;
int oldstyle = 0;
int idx2def = 0;

#define CFG_FILE "admin.conf"
#define START_SCRIPT "/admin.sh -start"
#define INIT_SCRIPT "/admin.sh -init"
#define SAVE_SCRIPT "/admin.sh -save"

typedef struct _admin {
   char *name;
   char *value;
   char type;
   int length;
   char *choices;
   char *scriptName;
   char *desc;
   char *sValue;
   int  iValue;
   int  iValMin;
   int  iValMax;
   int  group;
   char *itemStrings;
   const char * lItems[MAX_LISTITEMS];
   int numLItems;
   char *allowed;
} ADMIN_ENTRY;


class cMenuSetupAdmin : public cMenuSetupPage {
private:
   ADMIN_ENTRY *admTable[ MAX_ENTRIES ];
   char configFile[254];
   void FreeTable(int);
   void AddMenuEntry( ADMIN_ENTRY *admEntry );
   bool isSubmenu;
   bool usePageUpDn;
   bool CheckChanged(void);
   bool bDontCheckChanged;
   bool bChanged;
   bool bStored;
   bool bRestart;
   int grpNum;
protected:
   virtual void Store(void);
public:
   cMenuSetupAdmin(void);
   ~cMenuSetupAdmin(void);
   cMenuSetupAdmin( ADMIN_ENTRY **admTable, int groupNum );
   virtual eOSState ProcessKey(eKeys Key);
};


// --- cMenuSetupAdmin --------------------------------------------------------

cMenuSetupAdmin::cMenuSetupAdmin(void)
{
   int i = 0;
   int actGroup = 0;
   int numGroup = 0;
   int j;
   char *p1, *p2;
   char buffer[512];

   usePageUpDn = false;

   bChanged = false;
   bStored = false;
   bRestart = false;
   strcpy(configFile,AddDirectory( cPlugin::ConfigDirectory(), "admin/" ));
   strcat(configFile,CFG_FILE);
   strcpy(buffer,AddDirectory( cPlugin::ConfigDirectory(), "admin" ));

   strcat(buffer, START_SCRIPT);
   isyslog( "Executing <%s>", buffer );
   system( buffer );

   SetHasHotkeys();
   isSubmenu = false;
   bDontCheckChanged = false;
   grpNum = 0;
   isyslog( "CfgFile: %s", configFile );

   FILE *fhdl = fopen( configFile, "r" );
   if( fhdl != NULL ) {
      static char buffer[ 2048 ];
      int offset;
      unsigned int maxLen;

      SetSection( "Admin" );
      while( fgets( buffer, sizeof( buffer ), fhdl ) != NULL ) {
         buffer[ strlen( buffer ) - 1 ] = '\0';
         admTable[i]=( ADMIN_ENTRY * )calloc( sizeof( ADMIN_ENTRY ), 1 );
         offset = 0;
         if( buffer[ 0 ] == '#' && buffer[1] == '!' )
            offset = 2;

         if( buffer[0] == '/' || offset > 0 ) {
            admTable[i]->desc = NULL;
            sscanf( buffer + offset, "%a[^:]:%a[^:]:%a[^:]:%c:%d:%a[^:]:%a[^:]:",
                    &(admTable[i]->scriptName),
                    &(admTable[i]->name),
                    &(admTable[i]->value),
                    &(admTable[i]->type),
                    &(admTable[i]->length),
                    &(admTable[i]->choices),
                    &(admTable[i]->desc ) );

            /* if empty value doit again */
            if( admTable[i]->desc == NULL ) {
               FreeTable( i );
               sscanf( buffer, "%a[^:]:%a[^:]::%c:%d:%a[^:]:%a[^:]:",
                       &(admTable[i]->scriptName),
                       &(admTable[i]->name),
                       &(admTable[i]->type),
                       &(admTable[i]->length),
                       &(admTable[i]->choices),
                       &(admTable[i]->desc ) );
            }
            admTable[i]->group = actGroup;
            maxLen = 0;
            switch( admTable[i]->type ) {
               case 'A':
                  admTable[i]->allowed = (char *)calloc(256,1);
                  if( admTable[i]->choices[0] == '-'       && 
                      strlen(admTable[i]->choices) == 2    &&
                      strchr("dDfF",admTable[i]->choices[1]) != NULL ) {
                     strcpy(admTable[i]->allowed, FNAME_CHARS);
                  }
                  else {
                     p1 = strstr(admTable[i]->choices, "a-z");
                     if( p1 )
                        strcat( admTable[i]->allowed, LOW_CHARS );
                     p1 = strstr(admTable[i]->choices, "A-Z");
                     if( p1 )
                        strcat( admTable[i]->allowed, UP_CHARS );
                     p1 = strstr(admTable[i]->choices, "0-9");
                     if( p1 )
                        strcat( admTable[i]->allowed, NUM_CHARS );
                     p1 = admTable[i]->choices;
                     p2 = admTable[i]->allowed + strlen(admTable[i]->allowed);
                     while( *p1 != '\0' ) {
                        if( strncmp(p1, "a-z", 3) && strncmp(p1, "A-Z", 3) && strncmp(p1, "0-9", 3) ) {
                           *p2 = *p1;
                           p2++;
                           p1++;
                        }
                        else
                           p1 += 3;
                     }
                  }
                  maxLen = admTable[i]->length;

                  admTable[i]->sValue = ( char * )calloc( maxLen + 1, 1 );
                  if( admTable[i]->value != NULL )
                     strncpy( admTable[i]->sValue, admTable[i]->value, maxLen );

                  break;
               case 'F':
                  maxLen = strlen( admTable[i]->value );
                  admTable[i]->sValue = ( char * )calloc( maxLen + 3, 1 );
                  strcpy( admTable[i]->sValue, "  " );
                  strcat( admTable[i]->sValue, admTable[i]->value );

                  break;
               case 'I':
                  maxLen = 10;
                  admTable[i]->iValue = atoi( admTable[i]->value );
                  p1 = strchr( admTable[i]->choices, ',' );
                  if( p1 != NULL ) {
                     *p1 = '\0';
                     p1++;
                     admTable[i]->iValMin = atoi(admTable[i]->choices);
                     admTable[i]->iValMax = atoi(p1);
                     maxLen = strlen( p1 ) + 1;
                     p1--;
                     *p1 = ',';
                  }
                  else
                     admTable[i]->choices[0] = '\0';

                  break;
               case 'B':
                  maxLen = 1;
                  admTable[i]->itemStrings = strdup( admTable[i]->choices );
                  p1 = strchr( admTable[i]->itemStrings, ',' );
                  admTable[i]->iValue = atoi( admTable[i]->value );
                  if( p1 != NULL ) {
                     admTable[i]->lItems[0] = admTable[i]->itemStrings;
                     *p1 = '\0';
                     p1++;
                     admTable[i]->lItems[1] = p1;
                  }
                  break;
               case 'L':
                  admTable[i]->itemStrings = strdup( admTable[i]->choices );
                  admTable[i]->iValue = 0;        
                  j = 0;
                  p1 = admTable[i]->itemStrings;
                  p2 = strchr( p1, ',' );
                  while( p1 != NULL && j < MAX_LISTITEMS - 1 ) {
                     if( p2 != NULL )
                        *p2 = '\0';
                     admTable[i]->lItems[j] = p1;
                     if( ! oldstyle && ! strcmp( p1, admTable[i]->value ) )
                        admTable[i]->iValue = j;

                     if( strlen( p1 ) >= maxLen )
                        maxLen = strlen( p1 ) + 1;

                     if( p2 != NULL ) {
                        p1 = p2 + 1;
                        p2 = strchr( p1, ',' );
                     }
                     else
                        p1 = NULL;
                     j++;
                  }
                  admTable[i]->numLItems = j;
                  admTable[i]->lItems[j] = NULL;
                  if( oldstyle )
                     admTable[i]->iValue = atoi( admTable[i]->value );

                  break;
               default:
                  printf( "Illegal type <%c>\n", admTable[i]->type );
                  FreeTable( i );
                  admTable[i]->type = '\0';
                  admTable[i]->desc = (char *) malloc( strlen( buffer ) + 3 );
                  if( offset == 0 ) {
                     strcpy( admTable[i]->desc, "#!" );
                     strcat( admTable[i]->desc, buffer );
                  }
                  else
                     strcpy( admTable[i]->desc, buffer );

                  break;

            }
            if( admTable[i]->type != '\0' || admTable[i]->value == NULL || maxLen > strlen( admTable[i]->value ) ) {
               char * nVal = (char *)calloc(maxLen + 1,1); 
               if( admTable[i]->value ) {
                  strncpy( nVal, admTable[i]->value, maxLen );
                  free( admTable[i]->value );
               }
               admTable[i]->value = nVal;
            }

            if( actGroup == 0 && admTable[i]->type != '\0' )
               AddMenuEntry( admTable[i] );
         }
         else {
            admTable[i]->desc = (char *) malloc( strlen( buffer ) + 1 );
            strcpy( admTable[i]->desc, buffer );
            if( buffer[ 0 ] == ':' ) {
               if( strlen( buffer ) > 1 && buffer[1] != ' ' ) {
                  if( numGroup < MAX_GROUPS )
                     numGroup++;

                  actGroup = numGroup;
                  Add( new cOsdItem( hk( admTable[i]->desc + 1 ), (eOSState)(actGroup+STATE_GROUPS) ) );
               }
               else
                  actGroup = 0;
            }
            else {
               if( buffer[ 0 ] == '-' || ( buffer[ 0 ] == '#' && buffer[1] == '!' ) ) {
                  admTable[i]->group = actGroup;
                  if( actGroup == 0 )
                     Add( new cOsdItem( admTable[i]->desc + 1, osUnknown, false ) );
               }
            }
         }
         i++;
      }
      Add( new cOsdItem( "", osUnknown, false ) );
      Add( new cMenuEditBoolItem( tr("Menu entry"), (int *)&mainMenuEntry ) );
      SetHelp( tr("Save"), tr("SaveExit"), tr("SaveRestart"), "" );
      admTable[i]=NULL;
      fclose( fhdl );
   }
   else {
      isyslog( "Error opening <%s>\n", configFile );
      Add( new cOsdItem( tr( "Config file not found" ), osUnknown, false ) );
   }
}

cMenuSetupAdmin::cMenuSetupAdmin( ADMIN_ENTRY *admTable[], int groupNum )
{
   int i = 0;
   int cnt = 0;
   isSubmenu = true;
   char * title = NULL;

   grpNum = groupNum;
   usePageUpDn = true;
   bDontCheckChanged = false;
   while( i < MAX_ENTRIES && admTable[i] != NULL && admTable[i]->group != groupNum ) {
      if( admTable[i]->desc && *(admTable[i]->desc) == ':' )
         title = admTable[i]->desc;

      i++;
   }

   while( i < MAX_ENTRIES && admTable[i] != NULL && admTable[i]->group == groupNum ) {
      AddMenuEntry( admTable[i] );
      if( admTable[i]->type == 'A' )
         usePageUpDn = false;

      cnt++;
      i++;
   }
   if( cnt > 50 && usePageUpDn )
      SetHelp( "", tr("PageUp"), tr("PageDown"), "" );
   else {
      SetHelp( "", "", "", "" );
      usePageUpDn = false;
   }

   SetTitle( title + 1 );
}


cMenuSetupAdmin::~cMenuSetupAdmin()
{
   if( !isSubmenu ) {
      if( !bDontCheckChanged && CheckChanged() && Interface->Confirm(tr("Save changes?")) )
         Store();

      for( int i = 0; i < MAX_ENTRIES && admTable[i] != NULL; i++ ) {
         FreeTable( i );
         free( admTable[ i ] );
      }
      if( bStored ) {
         char buffer[ 512 ];
         strcpy(buffer,AddDirectory( cPlugin::ConfigDirectory(), "admin" ));
         strcat(buffer, SAVE_SCRIPT);
         isyslog( "Executing <%s>", buffer );
         system( buffer );
      }
      else
         isyslog( "Leaving admin plugin without saving" );

      if( bRestart )
         exit( 0 );
   }
}


void cMenuSetupAdmin::Store(void)
{
   FILE *fhdl = fopen( configFile, "w" );
   const char *valPtr = NULL;
   char listIndex[16];
// fprintf( fhdl, "# This file contains the tasks for the admin plugin\n" );
// fprintf( fhdl, "# Syntax:\n" );
// fprintf( fhdl, "# <script>:<name>:<value>:<type>:<length>:<choices>:<description>:\n" );

   Skins.Message(mtInfo, tr("Saving settings"),1);
   SetupStore(SETUP_MAINMENUENTRY, mainMenuEntry);
   Setup.Save();

   for( int i=0; i < MAX_ENTRIES && admTable[i] != NULL; i++ ) {
      if( admTable[i]->type != '\0' ) {
         switch( admTable[i]->type ) {
            case 'A':
               valPtr = admTable[i]->sValue;
               break;
            case 'F':
               valPtr = admTable[i]->value;
               break;
            case 'I':
               strcpy( admTable[i]->value, itoa( admTable[i]->iValue ) );
               valPtr = admTable[i]->value;
               break;
            case 'B':
               strcpy( admTable[i]->value, itoa( admTable[i]->iValue ) );
               valPtr = admTable[i]->value;
               break;
            case 'L':
               strcpy( admTable[i]->value, admTable[i]->lItems[admTable[i]->iValue] );
               if( oldstyle ) {
                  strcpy( listIndex, itoa( admTable[i]->iValue ) );
                  valPtr = listIndex;
               }
               else
                  valPtr = admTable[i]->lItems[admTable[i]->iValue];

               if( idx2def )
                  admTable[i]->length = admTable[i]->iValue;

               break;
            default:
               printf( "Illegal type <%c>\n", admTable[i]->type );
               break;
         }
         fprintf( fhdl, "%s:%s:%s:%c:%d:%s:%s:\n",
                  admTable[i]->scriptName,
                  admTable[i]->name,
                  valPtr,
                  admTable[i]->type,
                  admTable[i]->length,
                  admTable[i]->choices,
                  admTable[i]->desc );
      }
      else
         fprintf( fhdl, "%s\n", admTable[i]->desc );
   }
   fclose( fhdl );

   bStored = true;
   bChanged = false;
}


bool cMenuSetupAdmin::CheckChanged(void)
{
   if( !bChanged ) {
      for( int i=0; i < MAX_ENTRIES && admTable[i] != NULL && !bChanged; i++ ) {
         if( admTable[i]->type != '\0' ) {
            switch( admTable[i]->type ) {
               case 'A':
                  if( strcmp( admTable[i]->value, admTable[i]->sValue ) )
                     bChanged = true;
                  break;
               case 'L':
                  if( strcmp( admTable[i]->value, admTable[i]->lItems[admTable[i]->iValue] ))
                     bChanged = true;
                  break;
               case 'I':
               case 'B':
                  if( atoi( admTable[i]->value ) != admTable[i]->iValue )
                     bChanged = true;
                  break;
            }
         }
      }
   }

   return bChanged;
}


void cMenuSetupAdmin::AddMenuEntry( ADMIN_ENTRY *admEntry )
{
   switch( admEntry->type ) {
      case 'A':
         Add(new cMenuEditStrItem( admEntry->desc, admEntry->sValue,
                                   admEntry->length + 1, admEntry->allowed ) );
         break;
      case 'F':
         admEntry->iValue = 0;
         if( strlen( admEntry->value ) > 16 ) {
            admEntry->lItems[0] = "";
            Add(new cMenuEditStraItem( admEntry->desc, &(admEntry->iValue), 1, admEntry->lItems));
            Add(new cOsdItem( admEntry->sValue, osUnknown, false ));
         }
         else {
            admEntry->lItems[0] = admEntry->value;
            Add(new cMenuEditStraItem( admEntry->desc, &(admEntry->iValue), 1, admEntry->lItems));
         }
         break;
      case 'I':
         if( admEntry->iValMin != admEntry->iValMax )
            Add(new cMenuEditIntItem( admEntry->desc, &(admEntry->iValue),
                                      admEntry->iValMin, admEntry->iValMax ));
         else
            Add(new cMenuEditIntItem( admEntry->desc, &(admEntry->iValue)));
         break;
      case 'B':
         if( admEntry->lItems[0] != NULL )
            Add(new cMenuEditBoolItem( admEntry->desc, &(admEntry->iValue),
                                       admEntry->lItems[0], admEntry->lItems[1] ));
         else
            Add(new cMenuEditBoolItem( admEntry->desc, &(admEntry->iValue)));
         break;
      case 'L':
         Add(new cMenuEditStraItem( admEntry->desc, &(admEntry->iValue), admEntry->numLItems, admEntry->lItems));
         break;
      default:
         Add( new cOsdItem( admEntry->desc + 1, osUnknown, false ) );
   }
}

void cMenuSetupAdmin::FreeTable( int idx )
{
   if( admTable[idx]->name != NULL ) {
      free( admTable[idx]->name );
      admTable[idx]->name = NULL;
   }

   if( admTable[idx]->value != NULL ) {
      free( admTable[idx]->value );
      admTable[idx]->value = NULL;
   }

   if( admTable[idx]->choices != NULL ) {
      free( admTable[idx]->choices );
      admTable[idx]->choices = NULL;
   }

   if( admTable[idx]->itemStrings != NULL ) {
      free( admTable[idx]->itemStrings );
      admTable[idx]->itemStrings = NULL;
   }

   if( admTable[idx]->scriptName != NULL ) {
      free( admTable[idx]->scriptName );
      admTable[idx]->scriptName = NULL;
   }

   if( admTable[idx]->desc != NULL ) {
      free( admTable[idx]->desc );
      admTable[idx]->desc = NULL;
   }

   if( admTable[idx]->allowed != NULL ) {
      free( admTable[idx]->allowed );
      admTable[idx]->allowed = NULL;
   }
}

eOSState cMenuSetupAdmin::ProcessKey(eKeys Key)
{
   eOSState state;
   bool bHadSubMenu = HasSubMenu();

   state = cOsdMenu::ProcessKey(Key);

   if( bHadSubMenu )
      return state;

   switch( Key ) {
      case kOk:
         if( state != osContinue ) {
            if( state > STATE_GROUPS )
               return AddSubMenu( new cMenuSetupAdmin( (ADMIN_ENTRY **)admTable, state - STATE_GROUPS ) );

            if( isSubmenu )
               state = osBack;
            else
               state = osContinue;
         }
         break;
      case kRed:
         if( !isSubmenu )
            Store();
         break;
      case kGreen:
         if( !isSubmenu ) {
            Store();
            state = osBack;
         }
         else {
            if( usePageUpDn )
               PageUp();
         }
         break;
      case kYellow:
         if( !isSubmenu ) {
            Store();
            if( !cRecordControls::Active() || Interface->Confirm(tr("Recording - restart VDR anyway?")) )
               bRestart = true;
            state = osBack;
         }
         else {
            if( usePageUpDn )
               PageDown();
         }
         break;
      default:
         break;
   }

   return state;
}



class cPluginAdmin : public cPlugin {
public:
   cPluginAdmin(void);
   virtual ~cPluginAdmin();
   virtual const char *Version(void) { return VERSION;}
   virtual bool Initialize(void);
   virtual void Housekeeping(void);
   virtual const char *Description(void) { return tr(DESCRIPTION);}
   virtual const char * MainMenuEntry(void) { return mainMenuEntry ? tr(MAINMENUENTRY) : NULL;}
   virtual cOsdObject *MainMenuAction(void);
   virtual cMenuSetupPage *SetupMenu(void);
   virtual bool SetupParse(const char *Name, const char *Value);
   virtual const char *CommandLineHelp(void);
   virtual bool ProcessArgs(int argc, char *argv[]);
};


// --- cPluginAdmin ----------------------------------------------------------

cPluginAdmin::cPluginAdmin(void)
{
   // Initialize any member variables here.
   // DON'T DO ANYTHING ELSE THAT MAY HAVE SIDE EFFECTS, REQUIRE GLOBAL
   // VDR OBJECTS TO EXIST OR PRODUCE ANY OUTPUT!
}

cPluginAdmin::~cPluginAdmin()
{
   // Clean up after yourself!
}


bool cPluginAdmin::Initialize(void)
{
   // Start any background activities the plugin shall perform.
   char buffer[512];

   strcpy(buffer,AddDirectory( cPlugin::ConfigDirectory(), "admin" ));
   strcat(buffer, INIT_SCRIPT);
   isyslog( "Executing <%s>", buffer );
   system( buffer );
   return true;
}

void cPluginAdmin::Housekeeping(void)
{
   // Perform any cleanup or other regular tasks.
}

cOsdObject *cPluginAdmin::MainMenuAction(void)
{
   // Perform the action when selected from the main VDR menu.
   return new cMenuSetupAdmin();
}

cMenuSetupPage *cPluginAdmin::SetupMenu(void)
{
   // Return a setup menu in case the plugin supports one.
   return new cMenuSetupAdmin();
}

bool cPluginAdmin::SetupParse(const char *Name, const char *Value)
{
   // Parse your own setup parameters and store their values.
   if( !strcasecmp(Name, SETUP_MAINMENUENTRY) )
      mainMenuEntry = atoi(Value);
   else
      return false;

   return true;
}

const char *cPluginAdmin::CommandLineHelp(void)
{
   // Return a string that describes all known command line options.
   static char *help_str=0;

   free( help_str );
   asprintf( &help_str, "  -o, --oldstyle  Write index of a list element as value\n"
                        "                  (default is now the string)\n"
                        "  -i, --idx2def   Write index to the place of the default value\n" );
   return help_str;
}

bool cPluginAdmin::ProcessArgs(int argc, char *argv[])
{
   // Implement command line argument processing here if applicable.
   static struct option long_options[] = {
      { "oldstyle", no_argument, NULL, 'o'},
      { "idx2def",  no_argument, NULL, 'i'},
      { NULL}};

   int c, option_index = 0;

   while( ( c = getopt_long( argc, argv, "oi", long_options, &option_index ) ) != -1 ) {
      switch( c ) {
         case 'o':  oldstyle = 1; break;
         case 'i':  idx2def = 1; break;
         default:  return false;
      }
   }

   return true;
}

VDRPLUGINCREATOR(cPluginAdmin); // Don't touch this!
