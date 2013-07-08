module ApplicationHelper

	def display_header(heads)

		t_head = content_tag :thead do 
			content_tag :tr do 
				heads.each {|head| concat(content_tag(:th, head.upcase.to_s))}
			end
		end
		t_head
	end

	def display_row(cells)

		t_row = content_tag :tr do 
			cells.each do |cell| 
					concat(content_tag(:td, cell))
			end
		end

		t_row
	end

end
