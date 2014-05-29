/**
 * JBoss, Home of Professional Open Source
 * Copyright Red Hat, Inc., and individual contributors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * 	http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.jboss.quickstarts.wfk.contacts.util;

import org.apache.deltaspike.security.api.authorization.AccessDeniedException;

import javax.ejb.EJBException;
import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.Status;
import javax.ws.rs.ext.ExceptionMapper;
import javax.ws.rs.ext.Provider;

/**
 * A JAX-RS exception mapper that maps {@link AccessDeniedException} to
 * respond with HTTP {@link Status#UNAUTHORIZED} status.
 */
@Provider
public class EJBExceptionMapper implements ExceptionMapper<EJBException> {

    @Context
    private HttpServletRequest request;

    @Override
    public Response toResponse(EJBException exception) {
        if (exception.getCausedByException() instanceof  AccessDeniedException) {
            String origin = request.getHeader("Origin");
            if (origin != null) {
                return Response.status(Status.UNAUTHORIZED)
                        .header("Access-Control-Allow-Origin", origin)
                        .header("Access-Control-Allow-Credentials", true)
                        .build();
            } else {
                return Response.status(Status.UNAUTHORIZED).build();
            }
        }
        throw exception;
    }
}
