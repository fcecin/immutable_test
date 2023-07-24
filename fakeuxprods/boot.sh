#!/bin/bash

# Search for "127.0.0.1:" to fix the transaction/HTTP port number as needed (set to 8888 by default)

CLEOS="leap/build/bin/cleos"

#$CLEOS wallet unlock --password <wallet-password-here>

# --- Create system accounts
# Create account eosio.bpay (fund per-block bucket)
# Create account eosio.msig (on-chain multi-signature helper)
# Create account eosio.names (where bidname revenues go)
# Create account eosio.ram (where buyram proceeds go)
# Create account eosio.ramfee (where buyram fees go)
# Create account eosio.saving (unallocated inflation)
# Create account eosio.stake (where delegated stakes go)
# Create account eosio.token (main multi-currency contract, including UTX)
# Create account eosio.token2 (main multi-currency contract, including UTX) ????? ---> probably not needed; skipped
# Create account eosio.vpay (fund per-vote bucket)
# Create account eosio.rex
$CLEOS create account eosio eosio.bpay EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
$CLEOS create account eosio eosio.msig EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
$CLEOS create account eosio eosio.names EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
$CLEOS create account eosio eosio.ram EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
$CLEOS create account eosio eosio.ramfee EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
$CLEOS create account eosio eosio.saving EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
$CLEOS create account eosio eosio.stake EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
$CLEOS create account eosio eosio.token EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
$CLEOS create account eosio eosio.vpay EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
$CLEOS create account eosio eosio.rex EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV


# --- Install system contracts
# Setting eosio.msig code for account eosio.msig
# Setting eosio.token code for account eosio.token
$CLEOS set contract eosio.token   ../uxcontracts/  eosio.token.wasm     eosio.token.abi
$CLEOS set contract eosio.msig    ../uxcontracts/  eosio.msig.wasm      eosio.msig.abi

# --- UX contracts

# Create account eosio.freeze
# Create account eosio.info
# Create account bridge
$CLEOS create account eosio eosio.freeze EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
$CLEOS create account eosio eosio.info EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
$CLEOS create account eosio bridge EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV

# Setting eosio.freeze code for account eosio.freeze
# Setting eosio.info code for account eosio.info
# Setting bridge code for account bridge
$CLEOS set contract eosio.freeze  ../uxcontracts/  eosio.freeze.wasm    eosio.freeze.abi
$CLEOS set contract eosio.info    ../uxcontracts/  eosio.info.wasm      eosio.info.abi
$CLEOS set contract bridge        ../uxcontracts/  bridge.wasm          bridge.abi

# --- Create tokens

# Creating the UTX currency symbol
# Creating the UTXRAM currency symbol
# Issuing initial UTX monetary base
# Issuing initial UTXRAM monetary base
$CLEOS push action eosio.token create '[ "eosio", "2500000000.0000 UTX" ]' -p eosio.token@active
$CLEOS push action eosio.token issue  '[ "eosio", "1000000000.0000 UTX", "initial issuance" ]' -p eosio
$CLEOS push action eosio.token create '[ "eosio",    "8000000.0000 UTXRAM" ]' -p eosio.token@active
$CLEOS push action eosio.token issue  '[ "eosio",     "800000.0000 UTXRAM", "initial issuance" ]' -p eosio

# --- Set system contract

# Enabling chain protocol features
# (This is probably the feature activation scheduling)
curl --request POST --url http://127.0.0.1:8888/v1/producer/schedule_protocol_feature_activations     -d '{"protocol_features_to_activate": ["0ec7e080177b2c02b278d5088611686b49d739925a92d9bfcacd7fc6b74053bd"]}'

sleep 3

# Setting eosio account contract to eosio.system 1.8.3
$CLEOS set contract eosio   ../eosio1.8.3/  eosio.system-1.8.3.wasm     eosio.system-1.8.3.abi

# Activated specific protocol features

#        - GET_SENDER
$CLEOS push action eosio activate '["f0af56d2c5a48d60a4a5b5c903edfb7db3a736a94ed589d0b797df33ff9d3e1d"]' -p eosio

#        - FORWARD_SETCODE
$CLEOS push action eosio activate '["2652f5f96006294109b3dd0bbde63693f55324af452b799ee137a81a905eed25"]' -p eosio

#        - ONLY_BILL_FIRST_AUTHORIZER
$CLEOS push action eosio activate '["8ba52fe7a3956c5cd3a656a3174b931d3bb2abb45578befc59f283ecd816a405"]' -p eosio

#        - RESTRICT_ACTION_TO_SELF
$CLEOS push action eosio activate '["ad9e3d8f650687709fd68f4b90b41f7d825a365b02c23a636cef88ac2ac00c43"]' -p eosio

#        - DISALLOW_EMPTY_PRODUCER_SCHEDULE
$CLEOS push action eosio activate '["68dcaa34c0517d19666e6b33add67351d8c5f69e999ca1e37931bc410a297428"]' -p eosio

#        - FIX_LINKAUTH_RESTRICTION
$CLEOS push action eosio activate '["e0fb64b1085cc5538970158d05a009c24e276fb94e1a0bf6a528b48fbc4ff526"]' -p eosio

#        - REPLACE_DEFERRED
$CLEOS push action eosio activate '["ef43112c6543b88db2283a2e077278c315ae2c84719a8b25f25cc88565fbea99"]' -p eosio

#        - NO_DUPLICATE_DEFERRED_ID
$CLEOS push action eosio activate '["4a90c00d55454dc5b059055ca213579c6ea856967712a56017487886a4d4cc0f"]' -p eosio

#        - ONLY_LINK_TO_EXISTING_PERMISSION
$CLEOS push action eosio activate '["1a99a59d87e06e09ec5b028a9cbb7749b4a5ad8819004365d02dc4379a8b7241"]' -p eosio

#        - RAM_RESTRICTIONS
$CLEOS push action eosio activate '["4e7bf348da00a945489b2a681749eb56f5de00b900014e137ddae39f48f69d67"]' -p eosio

#        - WEBAUTHN_KEY
$CLEOS push action eosio activate '["4fca8bd82bbd181e714e283f83e1b45d95ca5af40fb89ad3977b653c448f78c2"]' -p eosio

#        - WTMSIG_BLOCK_SIGNATURES
$CLEOS push action eosio activate '["299dcb6af692324b899b39f16d5a530a33062804e41f09dc97e9f156b4476707"]' -p eosio

# FIXME/TODO (I don't think we need this for local tests:) 
# Setting privileged account for eosio.msig

# Wait for protocol feature to correctly activate
sleep 3

# Setting eosio account from eosio.bios contract to eosio.system
#  - op: system.setcode
#    label: Setting eosio account from eosio.bios contract to eosio.system
#    data:
#      account: eosio
#      contract_name_ref: eosio.system
$CLEOS set contract eosio   ../uxcontracts/  eosio.system.wasm     eosio.system.abi

# Wait for protocol feature to correctly activate
sleep 3

# --- Init system contract
$CLEOS push action eosio init '["0", "4,UTX"]' -p eosio

