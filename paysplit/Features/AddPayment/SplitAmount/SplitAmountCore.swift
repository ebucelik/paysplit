//
//  SplitAmountCore.swift
//  paysplit
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 13.10.24.
//

import ComposableArchitecture
import Foundation

@Reducer
struct SplitAmountCore {
    @ObservableState
    struct State {
        var account: Account?
        var expenseDescription: String
        var expenseAmount: String
        var addedPeople: [Account]

        var createdExpenses: ViewState<[Expense]> = .none

        var expenses: [Expense]

        let numberFormatter = NumberFormatter()

        var isExpensesAmountFulfilled: Bool {
            numberFormatter.decimalSeparator = ","

            let expensesAmount = expenses.compactMap {
                numberFormatter.number(from: $0.expenseAmount)?.doubleValue
            }.reduce(0, +)

            return expensesAmount == numberFormatter.number(from: expenseAmount)?.doubleValue
            && expenses.allSatisfy({ (numberFormatter.number(from: $0.expenseAmount)?.doubleValue ?? 0) > 0 })
        }

        init(
            account: Account?,
            expenseDescription: String,
            expenseAmount: String,
            addedPeople: [Account]
        ) {
            self.expenseDescription = expenseDescription
            self.expenseAmount = expenseAmount

            let addedPeopleIncludingMyself = [
                Account(
                    id: account?.id ?? 0,
                    username: "",
                    firstname: "You",
                    lastname: "",
                    password: nil,
                    picturelink: account?.picturelink ?? "",
                    bankdetail: nil
                )
            ] + addedPeople
            self.addedPeople = addedPeopleIncludingMyself

            self.expenses = addedPeopleIncludingMyself.map { person in
                Expense(
                    creatorId: account?.id ?? 0,
                    debtorId: person.id,
                    expenseDescription: expenseDescription,
                    expenseAmount: "",
                    paid: false,
                    timestamp: 0
                )
            }
        }
    }

    enum Action: BindableAction {
        enum Delegate {
            case evaluateNextStep
        }

        case createExpenses
        case setCreatedExpenses(ViewState<[Expense]>)

        case delegate(Delegate)
        case binding(BindingAction<State>)
    }

    @Dependency(\.addPaymentService) var service

    var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .createExpenses:

                let timestamp = Date.now.timeIntervalSinceReferenceDate

                state.expenses = state.expenses.compactMap {
                    Expense(
                        creatorId: $0.creatorId,
                        debtorId: $0.debtorId,
                        expenseDescription: $0.expenseDescription,
                        expenseAmount: $0.expenseAmount,
                        paid: $0.paid,
                        timestamp: timestamp
                    )
                }

                return .run { [expenses = state.expenses] send in
                    await send(.setCreatedExpenses(.loading))

                    let expenses = try await self.service.addExpenses(expenses: expenses)

                    await send(.setCreatedExpenses(.loaded(expenses)))
                } catch: { error, send in
                    await send(.setCreatedExpenses(.error(error as? MessageResponse ?? error)))
                }

            case let .setCreatedExpenses(createdExpenses):
                state.createdExpenses = createdExpenses

                if case .loaded = createdExpenses {
                    return .send(.delegate(.evaluateNextStep))
                }

                return .none

            case .delegate, .binding:
                return .none
            }
        }
    }
}
