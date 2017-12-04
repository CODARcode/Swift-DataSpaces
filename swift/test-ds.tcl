
# TEST DS TCL

package require sds
package require turbine 1.0

proc rules { } { }

turbine::defaults
turbine::init $servers "Swift"
puts "turbine init ok"

if { [ adlb::rank ] == 0 } {
  sds_kv_put "mykey" "mydata"
} else {
  after 100
  puts "tcl: [ sds_kv_get mykey 100 ]"
}

turbine::start rules
turbine::finalize

puts OK
