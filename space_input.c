/* Use uinput to emit events 
 *
 * Read :  http://thiemonge.org/getting-started-with-uinput
 *
 */ 


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <linux/input.h>
#include <linux/uinput.h>


#define die(str, args...) do { \
	perror(str); \
	exit(EXIT_FAILURE); \
} while(0)

	int
main(void)
{
	int                    fd;
	struct uinput_user_dev uidev;
	struct input_event     ev;
	int                    dx, dy;
	int                    i;

	fd = open("/dev/uinput", O_WRONLY | O_NONBLOCK);
	if(fd < 0)
		die("error: open");

	if(ioctl(fd, UI_SET_EVBIT, EV_KEY) < 0)
		die("error: ioctl when setting EVBIT ");

	if(ioctl(fd, UI_SET_KEYBIT, KEY_SPACE) < 0)
		die("error: ioctl when setting KEYBIT ");

	memset(&uidev, 0, sizeof(uidev)); 
	snprintf(uidev.name, UINPUT_MAX_NAME_SIZE, "uinput-sample");
	uidev.id.bustype = BUS_USB;
	uidev.id.vendor  = 0x1;
	uidev.id.product = 0x1;
	uidev.id.version = 1;

	if(write(fd, &uidev, sizeof(uidev)) < 0)
		die("error: write");

	if(ioctl(fd, UI_DEV_CREATE) < 0)
		die("error: ioctl");

	sleep(5);

	for ( i = 0 ; i < 10000 ; i++) { 

		memset(&ev, 0, sizeof(ev));
		ev.type = EV_KEY;
		ev.code = KEY_SPACE; 
		ev.value = 1 ; 

		if(write(fd, &ev, sizeof(struct input_event)) < 0)
			die("error: write");
		else 
			printf("Space   \n " ); 

		sleep(0.6); 
		memset(&ev, 0, sizeof(ev));
		ev.type = EV_KEY;
		ev.code = KEY_SPACE; 
		ev.value = 0 ; 

		if(write(fd, &ev, sizeof(struct input_event)) < 0)
			die("error: write");
		else 
			printf("Space release  \n " ); 

		sleep(0.6); 

	}


	return 0 ; 

} 
