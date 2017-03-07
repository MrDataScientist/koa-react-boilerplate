import React from 'react';
import { Route } from 'react-router';

import { default as AppContainer } from './containers/AppContainer';
import HomeContainer from './containers/HomeContainer';
import NotFoundContainer from './containers/NotFoundContainer';

const routes = (
    <Route component={AppContainer}>
        <Route path="/" name="Home" component={HomeContainer} />
        <Route path="*" name="404" component={NotFoundContainer} />
    </Route>
);

export default routes;