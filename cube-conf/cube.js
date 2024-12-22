module.exports = {
  // Create a new appId for each team, this prevents teams from seeing each
  // other's data
  // https://cube.dev/docs/reference/configuration/config#contexttoappid
  contextToAppId: ({ securityContext }) => {
    return securityContext.team;
  },
 
  // Enforce a default value for `team` if one is not provided
  // in the security context
  // https://cube.dev/docs/reference/configuration/config#extendcontext
  extendContext: ({ securityContext }) => {
    if (!securityContext.team) {
      securityContext.team = "public";
    }
 
    return {
      securityContext,
    };
  },
 
  // Here we create a new security context for each team so that we can
  // use it in our data model later
  checkSqlAuth: (query, username) => {
    const securityContext = {
      team: username,
    };
 
    return {
      password: process.env.CUBEJS_SQL_PASSWORD,
      securityContext: securityContext,
    };
  },
};