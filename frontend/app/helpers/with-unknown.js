import Ember from 'ember';

export function withUnknown(params/*, hash*/) {
  let str = params[0],
      alt = (params.length > 1 ? params[1] : 'unknown');
  return (Ember.isEmpty(str)) ? alt : str;
}

export default Ember.Helper.helper(withUnknown);
