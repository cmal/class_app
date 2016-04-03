# coding: utf-8
require 'test_helper'

class KlassesIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:user1)
    @klass = klasses(:klass1)
    log_in_as(@admin)
    get klasses_path
  end
  test "index as admin including new and pagination and delete links" do
    assert_template 'klasses/index'
    assert_select 'a[href=?]', new_klass_path, text: '新增班级'
    assert_select 'div.pagination'
    first_page_of_klasses = Klass.paginate(page: 1)
    first_page_of_klasses.each do |klass|
      assert_select 'a[href=?]', klass_path(klass), text: klass.name
      assert_select 'a[href=?]', edit_klass_path(klass), text: '改名'
      assert_select 'a[href=?]', klass_path(klass), text: '删除',
                    method: :delete
    end
    assert_difference 'Klass.count', -1 do
      delete klass_path(@klass)
    end
  end
end
