/*
 * JBoss, Home of Professional Open Source
 * Copyright 2014, Red Hat, Inc. and/or its affiliates, and individual
 * contributors by the @authors tag. See the copyright.txt in the
 * distribution for a full listing of individual contributors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.jboss.quickstarts.wfk.contacts.security.authorization;

import org.apache.deltaspike.security.api.authorization.AccessDeniedException;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.Status;
import javax.ws.rs.ext.ExceptionMapper;
import javax.ws.rs.ext.Provider;

import java.util.HashMap;

/**
 * <p>Translates system exceptions to HTTP Status Codes.</p>
 *
 * @author pedroigor
 */
@Provider
public class RestExceptionMapper implements ExceptionMapper<AccessDeniedException> {

    @Inject
    private AuthorizationManager authorizationManager;

    @Context
    private HttpServletRequest request;

    @Override
    public Response toResponse(AccessDeniedException exception) {
        HashMap<String, String> message = new HashMap<String, String>();
        if (!authorizationManager.isLoggedIn()) {
            message.put("message", "Authentication Required");
            String origin = request.getHeader("Origin");
            if (origin != null) {
                return Response.status(Status.UNAUTHORIZED)
                        .header("Access-Control-Allow-Origin", origin)
                        .header("Access-Control-Allow-Credentials", true)
                        .entity(message)
                        .build();
            } else {
                return Response.status(Status.UNAUTHORIZED).entity(message).build();
            }
        }
        message.put("message", "Access Denied");
        return Response.status(Status.FORBIDDEN).entity(message).build();
    }

}