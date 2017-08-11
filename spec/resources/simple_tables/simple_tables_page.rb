# encoding:utf-8
#--
# The MIT License (MIT)
#
# Copyright (c) 2015, The Gamera Development Team. See the COPYRIGHT file at
# the top-level directory of this distribution and at
# http://github.com/gamera-team/gamera/COPYRIGHT.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#++

require_relative '../../../lib/gamera'

class SimpleTablesPage < Gamera::Page
  include Forwardable

  attr_reader :fruit_table, :vegetable_table

  def initialize
    super('/', %r{\/})

    fruit_headers = %w[Name Color Edit Delete]
    vegetable_headers = %w[Select Vegetable Edit Delete]

    @fruit_table = Gamera::PageSections::Table.new(headers: fruit_headers,
                                                   row_name: :fruit,
                                                   row_css: 'table.fruits tr + tr')

    @vegetable_table = Gamera::PageSections::Table.new(headers: vegetable_headers,
                                                       row_name: :vegetable,
                                                       row_css: 'table.vegetables tr + tr',
                                                       name_column: 'Vegetable',
                                                       row_class: VegetableTableRow,
                                                       row_editor: VegetableRowEditor.new,
                                                       row_deleter: VegetableRowDeleter.new)

    def_delegators :fruit_table,
                   :fruit, :fruits,
                   :has_fruit?, :has_fruits?,
                   :has_no_fruit?, :has_no_fruits?,
                   :edit_fruit, :delete_fruit

    def_delegators :vegetable_table,
                   :vegetable, :vegetables,
                   :has_vegetable?, :has_vegetables?,
                   :has_no_vegetable?, :has_no_vegetables?,
                   :edit_vegetable, :delete_vegetable
  end
end

class VegetableTableRow < Gamera::PageSections::TableRow
  def select_row
    find('input[type=checkbox]').set(true)
  end
end

class VegetableRowEditor
  def edit(table_row)
    table_row.find_link('Modify').click
  end
end

class VegetableRowDeleter
  def delete(table_row)
    table_row.find_link('Remove').click
  end
end
