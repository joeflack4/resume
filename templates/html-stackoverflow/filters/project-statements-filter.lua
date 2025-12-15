-- filters/project-statements-filter.lua
-- Pandoc Lua filter: Add should_show_statements flag to projects based on importance order

function Meta(meta)
  -- Get the top-n value from toggles
  local top_n = 0
  if meta.toggles and meta.toggles['top-n-projects-to-include-statements-blocks'] then
    top_n = tonumber(pandoc.utils.stringify(meta.toggles['top-n-projects-to-include-statements-blocks']))
  end

  -- Get the importance order map
  local importance_map = {}
  if meta['projects-importance-order-to-include-statements-blocks'] then
    for k, v in pairs(meta['projects-importance-order-to-include-statements-blocks']) do
      local order = tonumber(pandoc.utils.stringify(k))
      local project_name = pandoc.utils.stringify(v)
      importance_map[project_name] = order
    end
  end

  -- Helper function to check if a project should show statements
  local function should_include(project_name)
    -- Special case: -1 means "show all", as does 0 (not set) or any negative value
    if top_n <= 0 then
      return true  -- If top_n is -1, 0, or not set, include all
    end

    local order = importance_map[project_name]
    if order and order <= top_n then
      return true
    end
    return false
  end

  -- Process work-experience projects (nested)
  if meta['work-experience'] then
    for i, job in ipairs(meta['work-experience']) do
      if job.projects then
        for j, project in ipairs(job.projects) do
          if project.name then
            local project_name = pandoc.utils.stringify(project.name)
            project.should_show_statements = should_include(project_name)
          end
        end
      end
    end
  end

  -- Process standalone projects
  if meta.projects then
    for i, project in ipairs(meta.projects) do
      if project.name then
        local project_name = pandoc.utils.stringify(project.name)
        project.should_show_statements = should_include(project_name)
      end
    end
  end

  return meta
end
