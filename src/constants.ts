import { LogLevel } from '@aries-framework/core'

export const AGENT_PORT = process.env.AGENT_PORT ? Number(process.env.AGENT_PORT) : 3000
export const AGENT_NAME = process.env.AGENT_NAME || 'Ajna Mediator'
export const WALLET_NAME = process.env.WALLET_NAME || 'ajna-mediator'
export const WALLET_KEY = process.env.WALLET_KEY || 'animo-mediator-zFFzFFFhhh16z16171zzz2zz8x1891x87gy3z28x7a%$a#^8}}@'
export const AGENT_ENDPOINTS = process.env.AGENT_ENDPOINTS?.split(',') ?? [
  `http://165.22.221.123:${AGENT_PORT}`,
  `ws://165.22.221.123:${AGENT_PORT}`,
]

export const POSTGRES_HOST = process.env.POSTGRES_HOST
export const POSTGRES_USER = process.env.POSTGRES_USER
export const POSTGRES_PASSWORD = process.env.POSTGRES_PASSWORD
export const POSTGRES_ADMIN_USER = process.env.POSTGRES_ADMIN_USER
export const POSTGRES_ADMIN_PASSWORD = process.env.POSTGRES_ADMIN_PASSWORD

export const INVITATION_URL = process.env.INVITATION_URL

export const LOG_LEVEL = LogLevel.debug

export const IS_DEV = false
