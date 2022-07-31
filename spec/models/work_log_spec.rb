require 'rails_helper'

RSpec.describe 'WorkLog', type: :model do
  let!(:matter) { create(:matter) }
  let!(:task) { create(:task) }
  let!(:work_log) { create(:work_log, matter_id: matter.id, task_id: task.id) }

  describe 'validates' do
    context '正常系' do
      it '有効なファクトリを持つこと' do
        expect(work_log).to be_valid
      end
      it 'task_idがなくとも登録できること' do
        work_log.task_id = nil
        expect(work_log).to be_valid
      end
      it 'matter_idがなくとも登録できること' do
        work_log.matter_id = nil
        expect(work_log).to be_valid
      end
      it 'working_timeがなくとも登録できること' do
        work_log.working_time = nil
        expect(work_log).to be_valid
      end
    end
    context '準正常系' do
      # content
      it 'contentがない場合は登録できないこと' do
        work_log.content = nil
        work_log.valid?
        expect(work_log.errors).to be_added(:content, :blank)
      end
      # user_id
      it 'user_idがない場合は登録できないこと' do
        work_log.user_id = nil
        work_log.valid?
        expect(work_log.errors).to be_added(:user_id, :blank)
      end
      # worked_date
      it 'worked_dateがない場合は登録できないこと' do
        work_log.worked_date = nil
        work_log.valid?
        expect(work_log.errors).to be_added(:worked_date, :blank)
      end
      # working_time
      it 'working_timeが数字以外だと登録できないこと' do
        work_log.working_time = '二'
        work_log.valid?
        expect(work_log.errors).to be_added(:working_time, :not_a_number, value: '二')
      end
      it 'working_timeが整数以外だと登録できないこと' do
        work_log.working_time = 1.5
        work_log.valid?
        expect(work_log.errors).to be_added(:working_time, :not_an_integer, value: 1.5)
      end
      it 'working_timeが0未満だと登録できないこと' do
        work_log.working_time = -1
        work_log.valid?
        expect(work_log.errors).to be_added(:working_time, :greater_than_or_equal_to, count: 0, value: -1)
      end
      # detail_reflection
      it 'detail_reflectionがない場合は登録できないこと' do
        work_log.detail_reflection = nil
        work_log.valid?
        expect(work_log.errors).to be_added(:detail_reflection, :inclusion, value: nil)
      end
    end
  end
end
