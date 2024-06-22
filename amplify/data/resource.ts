import { type ClientSchema, a, defineData } from '@aws-amplify/backend';

const schema = a.schema({
  Todo: a
    .model({
      name: a.string().required(),
      description: a.string(),
      deadline: a.datetime(),
      state: a.enum(["Done", "InProgress", "NotStarted"])
    })
    .authorization(allow => [allow.publicApiKey()])
});

// Used for code completion / highlighting when making requests from frontend
export type Schema = ClientSchema<typeof schema>;

// defines the data resource to be deployed
export const data = defineData({
   schema,
   authorizationModes: {
       defaultAuthorizationMode: 'apiKey',
       apiKeyAuthorizationMode: { expiresInDays: 30 }
   }
});
