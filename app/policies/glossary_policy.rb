class GlossaryPolicy < Struct.new(:user, :glossary)
	def update?
		user && (user.admin_role? || user.sys_admin_role? )
	end
end