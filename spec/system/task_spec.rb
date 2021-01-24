require 'rails_helper'

RSpec.describe 'Task', type: :system do
  let(:project) { create(:project) }
  let(:task) { create(:task, project: project) }
  
  describe 'Task一覧' do
    context '正常系' do
      it '一覧ページにアクセスした場合、Taskが表示されること' do
        # TODO: ローカル変数ではなく let を使用してください
        visit project_tasks_path(project)
        expect(page).to have_content task.title
        expect(Task.count).to eq 1
        expect(current_path).to eq project_tasks_path(project)
      end

      it 'Project詳細からTask一覧ページにアクセスした場合、Taskが表示されること' do
        # FIXME: テストが失敗するので修正してください
        visit project_path(project)
        # click_link 'View Todos'
        # new_window = window_opened_by do
        #   click_link 'View Todo'
        # end
        # do ~ endは{}で書き換えることができるので、上記3行のブロックは下のように書き換え
        # target = _blankで新しいタブで開いているのでwindow_opened_byが必要になる
        within_window window_opened_by { click_link 'View Todo' } do
          expect(page).to have_content task.title
          expect(Task.count).to eq 1
          expect(current_path).to eq project_tasks_path(project)
        end
      end
    end
  end

  describe 'Task新規作成' do
    context '正常系' do
      it 'Taskが新規作成されること' do
        # TODO: ローカル変数ではなく let を使用してください
        visit project_tasks_path(project)
        click_link 'New Task'
        fill_in 'Title', with: 'test'
        click_button 'Create Task'
        expect(page).to have_content('Task was successfully created.')
        expect(Task.count).to eq 1
        expect(current_path).to eq '/projects/1/tasks/1'
      end
    end
  end

  describe 'Task詳細' do
    context '正常系' do
      it 'Taskが表示されること' do
        # TODO: ローカル変数ではなく let を使用してください
        visit project_task_path(project, task)
        expect(page).to have_content(task.title)
        expect(page).to have_content(task.status)
        expect(page).to have_content(task.deadline.strftime('%Y-%m-%d %H:%M'))
        expect(current_path).to eq project_task_path(project, task)
      end
    end
  end

  describe 'Task編集' do
    context '正常系' do
      it 'Taskを編集した場合、一覧画面で編集後の内容が表示されること' do
        # FIXME: テストが失敗するので修正してください
        visit edit_project_task_path(project, task)
        fill_in 'Deadline', with: Time.current
        click_button 'Update Task'
        click_link 'Back'
        # 空うめは_を使う https://docs.ruby-lang.org/ja/latest/class/Time.html#S_LOCAL
        expect(find('.task_list')).to have_content(Time.current.strftime('%_m/%d %H:%M'))
        expect(current_path).to eq project_tasks_path(project)
      end

      it 'ステータスを完了にした場合、Taskの完了日に今日の日付が登録されること' do
        # TODO: ローカル変数ではなく let を使用してください
        visit edit_project_task_path(project, task)
        select 'done', from: 'Status'
        click_button 'Update Task'
        expect(page).to have_content('done')
        expect(page).to have_content(Time.current.strftime('%Y-%m-%d'))
        expect(current_path).to eq project_task_path(project, task)
      end

      it '既にステータスが完了のタスクのステータスを変更した場合、Taskの完了日が更新されないこと' do
        # TODO: FactoryBotのtraitを利用してください
        # traitを使用したオーバーライド
        create(:task, :task_finished_status)
        visit edit_project_task_path(project, task)
        select 'todo', from: 'Status'
        click_button 'Update Task'
        expect(page).to have_content('todo')
        expect(page).not_to have_content(Time.current.strftime('%Y-%m-%d'))
        expect(current_path).to eq project_task_path(project, task)
      end
    end
  end

  describe 'Task削除' do
    context '正常系' do
      # FIXME: テストが失敗するので修正してください
      it 'Taskが削除されること' do
        visit project_tasks_path(project, task)
        # click_link 'Destroy'
        # page.driver.browser.switch_to.alert.accept #alartをaccept
        accept_alert { click_link 'Destroy' } #alartをaccept
        expect(find '.task_list').not_to have_content task.title #.task_listの中にtask.titleが入ってないことを確認。以下のexpectもこの指定が適応される
        expect(Task.count).to eq 0
        expect(current_path).to eq project_tasks_path(project)
      end
    end
  end
end
