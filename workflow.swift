import assert;
import io;
import launch;
import string;
import sys;

string rmethod;
void ready;
int availproc;

int htproc_x = 4;
int htproc_y = 3;
int htproc = htproc_x * htproc_y;
int swproc = 3;
int dsproc = 1;

availproc = turbine_workers();

app(void signal) check_conf_exists () {
       "./check_conf_exists.sh"
}

    program3 = "dataspaces_server";
    arguments3 = split("-s 1 -c 2", " ");
    printf("swift: launching %s", program3);
    exit_code3 = @par=dsproc launch(program3, arguments3);
    printf("swift: received exit code: %d", exit_code3);
    if(exit_code3 != 0)
    {
        printf("swift: The launched application did not succed.");
    }
    ready = check_conf_exists();

wait(ready) {
    program1 = "test_writer";
    arguments1 = split("DATASPACES 1 3 1 1 1 256 256 256 10 1", " ");
    printf("swift: launching: %s", program1);
    exit_code1 = @par=1 launch(program1, arguments1);
    printf("swift: received exit code: %d", exit_code1);
    if (exit_code1 != 0)
    {
        printf("swift: The launched application did not succeed.");
    }

    program2 = "test_reader";
    arguments2 = split("DATASPACES 1 3 1 1 1 256 256 256 10 2", " ");
    printf("swift: launching: %s", program1);
    exit_code2 = @par=1 launch(program2, arguments2);
    printf("swift: received exit code: %d", exit_code2);
    if (exit_code2 != 0)
    {
        printf("swift: The launched application did not succeed.");
    }
}
