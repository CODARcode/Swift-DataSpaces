
# TEST DS TCL

package require sds
package require turbine 1.0

proc rules { } { }

turbine::defaults
turbine::init $servers "Swift"
puts "turbine init ok"

if { [ adlb::rank ] == 0 } {
  puts send
}

turbine::start rules
turbine::finalize

puts OK
