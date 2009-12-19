#include <stdio.h>
#include "common.h"
#include "output.h"

static const char FILENAME[] = "output.c";

static void printOutputCapabilities() {
	int i, j;
	printf("%s::%s\n", FILENAME, __FUNCTION__);
	printf("Capabilities:\n");
	for (i = 0; AvailableOutput[i] != NULL; i++)	{
		printf("\t%s : ", AvailableOutput[i]->Name);
		for (j = 0; AvailableOutput[i]->Capabilities[j] != NULL; j++)
			printf("%s ", AvailableOutput[i]->Capabilities[j]);
		printf("\n");
	}
}

static void OutputAdd(Context_t  *context, char * port) {
	int i, j;
	printf("%s::%s\n", FILENAME, __FUNCTION__);
	for (i = 0; AvailableOutput[i] != NULL; i++)	
		for (j = 0; AvailableOutput[i]->Capabilities[j] != NULL; j++)
			if (!strcmp(AvailableOutput[i]->Capabilities[j], port)) {
				if (!strcmp("audio", port))
					context->output->audio = AvailableOutput[i];
				else if (!strcmp("video", port))
					context->output->video = AvailableOutput[i];
				else if (!strcmp("subtitle", port))
					context->output->subtitle = AvailableOutput[i];
				break;
			}
}

static void OutputDel(Context_t  *context, char * port) {
	int i, j;
	printf("%s::%s\n", FILENAME, __FUNCTION__);

    if (!strcmp("audio", port))
        context->output->audio = NULL;
    else if (!strcmp("video", port))
        context->output->video = NULL;
    else if (!strcmp("subtitle", port))
        context->output->subtitle = NULL;;

}

static int Command(Context_t  *context, OutputCmd_t command, void * argument) {
	//printf("%s::%s\n", FILENAME, __FUNCTION__);

	switch(command) {
		case OUTPUT_OPEN: {
			if (context->playback->isVideo)
				context->output->video->Command(context, OUTPUT_OPEN, "video");
			if (context->playback->isAudio)
				context->output->audio->Command(context, OUTPUT_OPEN, "audio");
			if (context->playback->isSubtitle)
				context->output->subtitle->Command(context, OUTPUT_OPEN, "subtitle");
			break;
		}
		case OUTPUT_CLOSE: {
			if (context->playback->isVideo)
				context->output->video->Command(context, OUTPUT_CLOSE, "video");
			if (context->playback->isAudio)
				context->output->audio->Command(context, OUTPUT_CLOSE, "audio");
			if (context->playback->isSubtitle)
				context->output->subtitle->Command(context, OUTPUT_CLOSE, "subtitle");
			break;
		}
		case OUTPUT_ADD: {
			OutputAdd(context, (char*) argument);
			break;
		}
		case OUTPUT_DEL: {
			OutputDel(context, (char*) argument);
			break;
		}
		case OUTPUT_CAPABILITIES: {
			printOutputCapabilities();
			break;
		}
		case OUTPUT_PLAY: {
			if (context->playback->isVideo)
				context->output->video->Command(context, OUTPUT_PLAY, "video");
			if (context->playback->isAudio)
				context->output->audio->Command(context, OUTPUT_PLAY, "audio");
			if (context->playback->isSubtitle)
				context->output->subtitle->Command(context, OUTPUT_PLAY, "subtitle");
			break;
		}
		case OUTPUT_STOP: {
			if (context->playback->isVideo)
				context->output->video->Command(context, OUTPUT_STOP, "video");
			if (context->playback->isAudio)
				context->output->audio->Command(context, OUTPUT_STOP, "audio");
			if (context->playback->isSubtitle)
				context->output->subtitle->Command(context, OUTPUT_STOP, "subtitle");
			break;
		}
		case OUTPUT_FLUSH: {
			if (context->playback->isVideo)
				context->output->video->Command(context, OUTPUT_FLUSH, "video");
			if (context->playback->isAudio)
				context->output->audio->Command(context, OUTPUT_FLUSH, "audio");
			//if (context->playback->isSubtitle)
			//	context->output->subtitle->Command(context, OUTPUT_FLUSH, "subtitle");
			break;
		}
		case OUTPUT_PAUSE: {
			if (context->playback->isVideo)
				context->output->video->Command(context, OUTPUT_PAUSE, "video");
			if (context->playback->isAudio)
				context->output->audio->Command(context, OUTPUT_PAUSE, "audio");
			//if (context->playback->isSubtitle)
			//	context->output->subtitle->Command(context, OUTPUT_PAUSE, "subtitle");
			break;
		}
		case OUTPUT_FASTFORWARD: {
			if (context->playback->isVideo)
				context->output->video->Command(context, OUTPUT_FASTFORWARD, "video");
			if (context->playback->isAudio)
				context->output->audio->Command(context, OUTPUT_FASTFORWARD, "audio");
			//if (context->playback->isSubtitle)
			//	context->output->subtitle->Command(context, OUTPUT_PAUSE, "subtitle");
			break;
		}
		case OUTPUT_CONTINUE: {
			if (context->playback->isVideo)
				context->output->video->Command(context, OUTPUT_CONTINUE, "video");
			if (context->playback->isAudio)
				context->output->audio->Command(context, OUTPUT_CONTINUE, "audio");
			//if (context->playback->isSubtitle)
			//	context->output->subtitle->Command(context, OUTPUT_CONTINUE, "subtitle");
			break;
		}
		case OUTPUT_AVSYNC: {
			if (context->playback->isVideo && context->playback->isAudio)
				context->output->audio->Command(context, OUTPUT_AVSYNC, "audio");

			break;
		}
		case OUTPUT_CLEAR: {
			if (context->playback->isVideo)
				context->output->video->Command(context, OUTPUT_CLEAR, "video");
			if (context->playback->isAudio)
				context->output->audio->Command(context, OUTPUT_CLEAR, "audio");
			//if (context->playback->isSubtitle)
			//	context->output->subtitle->Command(context, OUTPUT_CLEAR, "subtitle");
			break;
		}
		case OUTPUT_PTS: {
			if (context->playback->isVideo)
				return context->output->video->Command(context, OUTPUT_PTS, argument);
			if (context->playback->isAudio)
				return context->output->audio->Command(context, OUTPUT_PTS, argument);
			//if (context->playback->isSubtitle)
			//	return context->output->subtitle->Command(context, OUTPUT_PTS, "subtitle");
			break;
		}
		case OUTPUT_SWITCH: {
			if (context->playback->isAudio)
				return context->output->audio->Command(context, OUTPUT_SWITCH, "audio");
			break;
		}
		default:
			printf("OutputCmd not supported! %d\n", command);
			break;
	}

	return 0;
}

OutputHandler_t OutputHandler = {
	"Output",
	NULL,
	NULL,
	NULL,
	&Command,
};
