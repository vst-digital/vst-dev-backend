module ByProjectExtension
  def by_project(project)
    where(project_id: project)
  end
end