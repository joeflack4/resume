-- filters/toggle-override-filter.lua
-- Allows overriding toggle values via top-level metadata

function Meta(meta)
  -- Check for override_show_project_statements
  if meta.override_show_project_statements ~= nil then
    if not meta.toggles then
      meta.toggles = {}
    end
    meta.toggles.show_project_statements = meta.override_show_project_statements
  end

  -- Check for override_show_project_skills
  if meta.override_show_project_skills ~= nil then
    if not meta.toggles then
      meta.toggles = {}
    end
    meta.toggles.show_project_skills = meta.override_show_project_skills
  end

  -- Check for override_top_n_projects
  if meta.override_top_n_projects ~= nil then
    if not meta.toggles then
      meta.toggles = {}
    end
    meta.toggles['top-n-projects-to-include-statements-blocks'] = meta.override_top_n_projects
  end

  return meta
end
