###
# balance
#
# Usage examples:
#
#   bal
#     Show balances of all accounts (assets and liabilities) except
#     unavailable/suspended accounts.
#
#   bal -a|--all
#     Show balances of all accounts including unavailable/suspended accounts.
#
#   bal paypal
#     Show balances of all available PayPal accounts.
#
#   bal paypal payoneer
#     Show balances of all available PayPal and Payoneer accounts.
#
#   bal -- <ledger-cli options>
#     Pass additional ledger-cli options to the underlying ledger command.
#
#   watchexec -nc -- zsh -c 'source ~/.zshrc && bal'
#     Combine with watchexec to reload balance report on file change:
###
function bal() {
  local cmd='ledger -f ${LEDGER_FILE}'
  local flag_all

  zparseopts -D -F -K -E -- \
    {a,-all}=flag_all ||
    return 1

  local balance_format='%(ansify_if(ansify_if( justify(scrub(display_total), 20 + int(prepend_width), 20 + int(prepend_width), true, color), bold if should_bold), yellow if color and account =~ /^Assets:\\*Receivable/)) %(!options.flat ? depth_spacer : "") %-(ansify_if( ansify_if(partial_account(options.flat), blue if color), bold if should_bold))\n%/%$1\n%/%("-" * (20 + int(prepend_width)))\n'

  local options=(
    "--balance-format '$balance_format'"
    "--prepend_width 5"
    "--pedantic"
    "--no-pager"
  )
  if [[ -z "$flag_all" ]]; then
    local unavailable_accounts="$cmd accounts --limit 'has_meta(/^NOAVAIL$/)'"
    unavailable_accounts=$(eval ${unavailable_accounts} | paste -sd '|' -)
    options+="--limit 'not (account =~ /$unavailable_accounts/)'"
  fi

  local accounts=()
  while [[ -n "$@" ]]
  do
    if [[ $1 == '--' ]]; then; shift; break; fi
    accounts+=(
      "^assets and $1"
      "^liabilities and $1"
    )
    shift
  done
  if [[ -z "$accounts" ]]; then
    accounts=(
      '^assets'
      '^liabilities'
    )
  fi

  eval ${cmd} bal $accounts $options $@
}

###
# register
#
# Usage examples:
#
#   reg
#     Show all transactions.
#
#   reg paypal
#     Show all PayPal transactions.
###
function reg() {
  local cmd='ledger -f ${LEDGER_FILE}'
  local flag_help

  local options=(
    "--pedantic"
  )

  local accounts=()
  while [[ -n "$@" ]]
  do
    if [[ $1 == '--' ]]; then; shift; break; fi
    accounts+=$1
    shift
  done

  eval ${cmd} reg $accounts $options $@
}

###
# budget
#
# Usage examples:
#
#   budget -p [project_names]
#     Forecast income from projects. (balance)
#
#   budget -p proj_a proj_b
#     Forecast income from specific project names.
#
#   budget -p -- -b 1/31 -e 3/3
#     Forecast project incomes for a specific time frame.
#
#   budget -P [project_names]
#     Same as `-p` option but uses `register` command under the hood.
#
#   budget -e [account_names]
#     Show upcoming expense items. If account_names are not specified, all
#     accounts except "dev" (Expenses:Dev to be precise) are processed.
#
#   budget -e software
#     Show upcoming expense items only for "software" accounts.
#
#   budget -e software csup
#     Show upcoming expense items only for "software" and "csup" accounts.
#
#   budget -e -a
#     Show all expense items including past expenses.
#
#   budget -e dev -- and @project_name
#     Show all dev expense items for a specific project.
###
function budget() {
  local cmd='ledger -f ${BUDGET_LEDGER_FILE}'
  local flag_projects_total
  local flag_projects
  local flag_expenses
  local flag_all

  zparseopts -D -F -K -E -- \
    {p,-projects-total}=flag_projects_total \
    {P,-projects}=flag_projects \
    {e,-expenses}=flag_expenses \
    {a,-all}=flag_all ||
    return 1

  # forecast income from projects
  if (( $#flag_projects_total || $#flag_projects )); then
    local options=(
      '--effective'
      '--exchange $ --basis'
      "--no-pager"
    )
    local accounts=()
    while [[ -n "$@" ]]
    do
      if [[ $1 == '--' ]]; then; shift; break; fi
      accounts+=(
        "^assets:income and $1"
        "^liabilities and $1"
      )
      shift
    done
    if [[ -z "$accounts" ]]; then
      accounts=(
        "^assets:income"
        "^liabilities"
      )
    fi
    local ledger_command
    [[ -z "$flag_projects_total" ]] || { ledger_command='bal' }
    [[ -z "$flag_projects" ]] || { ledger_command='reg' }
    eval ${cmd} $ledger_command $accounts $options $@ && return
  fi

  # list expense items
  if (( $#flag_expenses )); then
    local register_format='%(ansify_if(ansify_if(justify(format_date(date), int(date_width)), green if color and date > today), bold if should_bold)) %(ansify_if(ansify_if(justify(truncated(payee, int(payee_width)), int(payee_width)), bold if color and !cleared and actual), bold if should_bold)) %(ansify_if(justify(scrub(display_amount), int(amount_width), 3 + int(meta_width) + int(date_width) + int(payee_width) + int(account_width) + int(amount_width) + int(prepend_width), true, color), bold if should_bold)) %(ansify_if(justify(scrub(display_total), int(total_width), 4 + int(meta_width) + int(date_width) + int(payee_width) + int(account_width) + int(amount_width) + int(total_width) + int(prepend_width), true, color), bold if should_bold))\n%/ %(justify(" ", int(date_width))) %(ansify_if(justify(truncated(has_tag("Payee") ? payee : " ", int(payee_width)), int(payee_width)), bold if should_bold)) %$3 %$4\n'

    local options=(
      "--register-format '$register_format'"
      "--effective"
      # "--related"
      "--exchange $ --basis"
      "--payee-width 40"
      "-S date"
      "--no-pager"
    )
    [[ -n "$flag_all" ]] || { options+='-b today' }

    local accounts=()
    while [[ -n "$@" ]]
    do
      if [[ $1 == '--' ]]; then; shift; break; fi
      accounts+="^expenses and $1"
      shift
    done
    if [[ -z "$accounts" ]]; then
      accounts=(
        "^expenses and not ^expenses:dev$"
      )
    fi

    eval ${cmd} reg $accounts $options $@ && return
  fi
}

###
# domains
###
function domains() {
  local cmd='ledger -f ${DOMAINS_LEDGER_FILE}'
  local flag_help
  local flag_all
  local usage=(
    "domains [options]\n"
    "\033[1mOPTIONS\033[0m"
    "\t\033[1m-h, --help\033[0m"
    "\t\tShow this help page."
    "\t\033[1m-a, --all\033[0m"
    "\t\tShow all domains including expired ones."
  )

  zparseopts -D -F -K -- \
    {h,-help}=flag_help \
    {a,-all}=flag_all ||
    return 1

  [[ -z "$flag_help" ]] || { print -l $usage && return }

  local register_format='%(ansify_if(ansify_if(justify(format_date(date), int(date_width)), green if color and date > today), bold if should_bold)) %(ansify_if(ansify_if(justify(truncated(payee, int(payee_width)), int(payee_width)), bold if color and !cleared and actual), bold if should_bold)) %(ansify_if(ansify_if(justify(truncated(display_account, int(account_width), int(abbrev_len)), int(account_width)), blue if color), bold if should_bold))\n%/ %(justify(" ", int(date_width))) %(ansify_if(justify(truncated(has_tag("Payee") ? payee : " ", int(payee_width)), int(payee_width)), bold if should_bold))\n'

  local options=(
    "--register-format '$register_format'"
    "--no-pager"
    "--payee-width 20"
  )
  [[ -n "$flag_all" ]] || { options+='-b today' }

  local accounts=()
  while [[ -n "$@" ]]
  do
    if [[ $1 == '--' ]]; then; shift; break; fi
    accounts+="not ^equity and $1"
    shift
  done
  [[ -n "$accounts" ]] || { accounts=("not ^equity") }

  eval ${cmd} reg $accounts $options $@
}
