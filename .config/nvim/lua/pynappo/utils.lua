local utils = {}
-- considers empty string and 0 falsy
function utils.truthy(object)
  local conditions = {object, {
    __index = function(table, key)
      return object
    end
  }}
  conditions.string = function(s) return #s ~= 0 end
  conditions.number = function(n) return n ~= 0 end
  return conditions[type(object)](object) and object
end

return utils
