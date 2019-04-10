require 'rails_helper'

describe 'タスク管理機能', type: :system do
  describe '一覧表示機能' do
    #ユーザーAの作成
    let(:user_a) { FactoryBot.create(:user, name: 'ユーザーA', email: 'a@example.com') }
    let(:user_b) { FactoryBot.create(:user, name: 'ユーザーB', email: 'b@example.com') }

    before do
      #ユーザーAのタスク作成
      FactoryBot.create(:task, name: '最初のタスク', user: user_a)
      #ユーザーAでログインする
      visit login_path
      fill_in 'メールアドレス', with: login_user.email 
      fill_in 'パスワード', with: login_user.password
      click_button 'ログインする'
    end

    context 'ユーザーAがログインしている時' do
      let(:login_user) { user_a }

      it do
        #作成済みのタスクの名前が画面上に表示されていることを確認
        expect(page).to have_content '最初のタスク'
      end
    end

    context 'ユーザーBがログインしている時' do
      let(:login_user) { user_b }
      it do
        expect(page).to have_no_content '最初のタスク'
      end
    end
  end
end
