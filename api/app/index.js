/* eslint-disable no-console */

import Koa from 'koa';
import koaMount from 'koa-mount';
import helmet from 'koa-helmet';

import bodyParser from 'koa-bodyparser';
import cors from 'kcors';
import chalk from 'chalk';

import config from 'config';
import logger from './middlewares/logger';
import notFound from './middlewares/notFound';

import winston from 'winston';

import db from '../config/initializers/sequelize';

import api from './api';

const app = new Koa()
    .use(cors())
    .use(helmet())
    .use(logger)
    .use(notFound)
    .use(bodyParser())
    .use(koaMount('/', api));

const main = async () => {
    const dbService = await db;
    await app.listen(config.port, () =>
        winston.info(chalk.black.bgGreen.bold(`${config.appName} - ${config.version}`)));
};

main().catch(error => winston.error(error));

export default app;