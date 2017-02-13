import files;
import location;

int NS = 1;
int NX = 1;
int NY = 1;
int NC = NX + NY; 

app(void signal) check_conf_exists () {
    "./check_conf_exists.sh"
}

@dispatch=WORKER
app(void signal) dataspaces_server(int nserver, int nclient) {
    "./dataspaces_server -s <<nserver>> -c <<nclient>>" 
}

@dispatch=WORKER
app(void signal) test_writer() {
    "./test_writer DATASPACES <<NX>> 3 1 1 1 128 128 128 50 1"
}

@dispatch=WORKER
app(void signal) test_reader() {
    "./test_reader DATASPACES <<NY>> 3 1 1 1 128 128 128 50 1"
}

foreach i in [0:n-1] {
    location L = location(i, HARD, RANK);
    @location=L dataspaces_server(NS, NC);
}
check_conf_exists() => {
    @par=NX test_writer();
    @par=NY test_reader();
}

