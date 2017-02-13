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

foreach i in [0:n-1] {
    location L = location(i, HARD, RANK);
    @location=L dataspaces_server(NS, NC);
}
check_conf_exists() => {
    //launch clients
}

