require "rspec"

require_relative "account"

describe Account do
  let(:account_number)   { "7001212345" }
  let(:account) { Account.new(account_number) }

  describe "#initialize" do
    context "with valid input" do
      it "creates a new Account" do
        expect(account).to be_a_kind_of(Account)
        expect(account.transactions[0]).to eq(0)
      end
    end

    context "with invalid input" do
      it "throws an argument error when not given an account number argument" do
        expect { Account.new }.to raise_error(ArgumentError)
      end

      it "throws an InvalidAccountNumberError error when not given a correct account number format" do
        expect { Account.new("70012123A5") }.to raise_error(InvalidAccountNumberError)
        expect { Account.new("700") }.to raise_error(InvalidAccountNumberError)
      end
    end
  end

  describe "#transactions" do
    it "returns the transactions of the account" do
      expect(account.transactions).to eq([0])
      # expect(account.transactions).to be_an_instance_of(Array)
      # expect(account.transactions.first).to be_a_kind_of(Numeric)
      account.deposit!(10.50)
      expect(account.transactions).to eq([0, 10.5])
      account.withdraw!(5)
      expect(account.transactions).to eq([0, 10.5, -5])
    end
  end

  describe "#balance" do
    it "returns correct Numeric balance" do
      expect(account.balance).to eq(0)
      expect(account.balance).to be_a_kind_of(Numeric)
      account.deposit!(10.50)
      expect(account.balance).to eq(10.5)
      account.withdraw!(5)
      expect(account.balance).to eq(5.5)
    end
  end

  describe "#account_number" do
    it "returns the obfuscate account number" do
      expect(account.acct_number).to match(/\*{6}2345/)
    end
  end

  describe "deposit!" do
    it "requires a numeric argument" do
      expect(account).to receive(:deposit!).with(a_kind_of(Numeric))
      account.deposit!(10.50)
    end

    it "throws an NegativeDepositError error when not given a positive number argument" do
        expect { account.deposit!(-10.50) }.to raise_error(NegativeDepositError)
    end

    it "returns the correct balance" do
      expect(account.deposit!(20.50)).to eq(20.50)
    end
  end

  describe "#withdraw!" do
    it "requires an numeric argument" do
      expect(account).to receive(:withdraw!).with(a_kind_of(Numeric))
      account.withdraw!(10.50)
    end

    it "throws an OverdraftError error when insufficient amount in the account" do
        expect { account.withdraw!(100) }.to raise_error(OverdraftError)
    end

    it "returns the correct balance" do
      account.deposit!(20.50)
      expect(account.withdraw!(10.50)).to eq(10.00)
    end
  end
end