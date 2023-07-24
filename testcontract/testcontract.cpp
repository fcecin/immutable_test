// Testcase for multi-index counting

#include <eosio/eosio.hpp>
#include <eosio/symbol.hpp>

using namespace eosio;
using namespace std;

class [[eosio::contract]] testcontract : public contract {
public:
   using contract::contract;

   testcontract( name receiver, name code, datastream<const char*> ds ) :
         contract(receiver, code, ds)
      {
      }

   [[eosio::action]]
   void testname1(name n) {
      uint64_t u64 = n.value;
      print("name u64: ", u64, "\n");
   }

   [[eosio::action]]
   void testsym1(symbol s) {
      uint64_t u64 = s.code().raw();
      print("sym u64: ", u64, "\n");
   }

};
