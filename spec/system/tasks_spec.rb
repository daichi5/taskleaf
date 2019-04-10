require 'rails_helper'

describe 'タスク管理機能', type: :system do
  #ユーザーAの作成
  let(:user_a) { FactoryBot.create(:user, name: 'ユーザーA', email: 'a@example.com') }
  let(:user_b) { FactoryBot.create(:user, name: 'ユーザーB', email: 'b@example.com') }
  let!(:task_a) { FactoryBot.create(:task, name: '最初のタスク', user: user_a) }

  before do
    #ユーザーAでログインする
    visit login_path
    fill_in 'メールアドレス', with: login_user.email 
    fill_in 'パスワード', with: login_user.password
    click_button 'ログインする'
  end

  shared_examples_for 'ユーザーAが作成したタスクが表示される' do
    it { expect(page).to have_content '最初のタスク' }
  end

  describe '一覧表示機能' do
    context 'ユーザーAがログインしている時' do
      let(:login_user) { user_a }

      it_behaves_like 'ユーザーAが作成したタスクが表示される'
    end

    context 'ユーザーBがログインしている時' do
      let(:login_user) { user_b }
      it do
        expect(page).to have_no_content '最初のタスク'
      end
    end
  end

  describe '詳細表示機能' do
    context 'ユーザーAがログインしているとき' do
      let(:login_user) { user_a }

      before do
        visit task_path(task_a)
      end

      it_behaves_like 'ユーザーAが作成したタスクが表示される'
    end
  end

  describe '新規作成機能' do
    let(:login_user) { user_a }
    
    before do
      #新規登録
      visit new_task_path
      fill_in '名称', with: task_name
      fill_in '詳しい説明', with: '説明'
      click_button '登録する'
    end

    context '新規作成画面で名称を入力した時' do
      let(:task_name) { 'タイトル' }
      it '正常に登録される' do
        expect(page).to have_selector '.alert-success', text: 'タイトル'
      end
    end

    context '新規作成画面で名称を入力しないとき' do
      let(:task_name) { '' }

      it 'エラーになる' do
        within '#error_explanation' do
          expect(page).to have_content '名称を入力してください'
        end
      end
    end

  end
end
